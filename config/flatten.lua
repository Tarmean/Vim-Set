-- if nvim is started by a tool like
-- editor = ["nvim", "--cmd", "let g:flatten_wait=1"]
--
-- and this is invoked from within a terminal buffer in nvim, we instead open in the existing nvim instance and waits for the file to be closed.
--
-- Flatten.nvim by itself always exits the blocked guest with 0 (see
-- `flatten.guest.maybe_block`, which ends in `qa!`). This layer adds
-- the equivalent of `:cq`:
--
--   :x / :wq            buffer was written  -> guest exits 0, jj commits
--   :q, :q!, :bd        never written       -> guest exits 1, jj aborts
--   :Cq [code]          abort explicitly    -> guest exits `code` (default 1)
--
--   which only requires public flatten.nvim hooks

local flatten = require("flatten")

---@type table<integer, { pipe: string?, written: boolean, code: integer? }>
local blocked = {}

--- Set g:flatten_exit_code in the guest, before flatten unblocks it.
local function set_guest_exit_code(pipe, code)
  if not pipe or pipe == "" then
    return
  end
  local ok, chan = pcall(vim.fn.sockconnect, "pipe", pipe, { rpc = true })
  if not ok or type(chan) ~= "number" or chan <= 0 then
    return
  end
  pcall(vim.rpcrequest, chan, "nvim_exec_lua", "vim.g.flatten_exit_code = ...", { code })
  pcall(vim.fn.chanclose, chan)
end

local function watch(bufnr, pipe)
  blocked[bufnr] = { pipe = pipe, written = false }
  local group = vim.api.nvim_create_augroup("flatten_exit_code_" .. bufnr, { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    buffer = bufnr,
    callback = function()
      if blocked[bufnr] then
        blocked[bufnr].written = true
      end
    end,
  })

  -- Same events flatten waits on, registered first so this runs first.
  vim.api.nvim_create_autocmd({ "QuitPre", "BufUnload", "BufDelete" }, {
    group = group,
    buffer = bufnr,
    once = true,
    callback = function()
      local st = blocked[bufnr]
      blocked[bufnr] = nil
      if not st then
        return
      end
      pcall(vim.api.nvim_del_augroup_by_id, group)
      set_guest_exit_code(st.pipe, st.code or (st.written and 0 or 1))
    end,
  })
end

flatten.setup({
  -- jj's temp files are `*.jjdescription`, which nvim already detects.
  block_for = {
    gitcommit = true,
    gitrebase = true,
    jjdescription = true,
  },
  hooks = {
    -- Runs in the guest, before anything else. Headless/embedded invocations
    -- (`nvim --headless` in a script, `nvim -l`, a git hook) have no business
    -- throwing buffers at the host session, so let them nest instead.
    should_nest = function()
      return #vim.api.nvim_list_uis() == 0
    end,
    -- Runs in the guest: tell the host how to talk back to us directly.
    guest_data = function()
      return { pipe = vim.v.servername }
    end,
    -- Runs in the host, before flatten arms its own unblock autocmd.
    post_open = function(opts)
      if opts.is_blocking then
        watch(opts.bufnr, type(opts.data) == "table" and opts.data.pipe or nil)
      end
    end,
  },
})

-- Guest side: honour the exit code the host pushed instead of always `qa!`.
local guest = require("flatten.guest")
local flatten_unblock = guest.unblock
function guest.unblock()
  local code = vim.g.flatten_exit_code
  if type(code) == "number" and code ~= 0 then
    vim.cmd("cquit " .. code) -- does not return
  end
  flatten_unblock()
end

-- :cq for one blocked edit, without taking this whole session down with it.
vim.api.nvim_create_user_command("Cq", function(o)
  local bufnr = vim.api.nvim_get_current_buf()
  local st = blocked[bufnr]
  if not st then
    vim.notify("no blocked editor is waiting on this buffer", vim.log.levels.ERROR)
    return
  end
  st.code = tonumber(o.args) or 1
  vim.cmd("bwipeout! " .. bufnr)
end, {
  nargs = "?",
  desc = "abort the editor blocked on this buffer (non-zero exit)",
})
