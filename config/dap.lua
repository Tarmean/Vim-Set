-- Debugger: nvim-dap (replaces vimspector).
-- Loaded from lspConfig.vim under `if has('nvim')`.
--
-- The keymaps below are a port of the old vimspector block: same
-- <localleader>d* prefix, same meanings, so muscle memory carries over. The
-- VISUAL_STUDIO function keys vimspector installed via
-- g:vimspector_enable_mappings are re-created here by hand, since nvim-dap has
-- no equivalent preset.
--
-- Language adapters live at the bottom. Each is guarded on its debug adapter
-- actually being installed, so a fresh machine loads this file cleanly and
-- only the languages you have adapters for show up.

local dap = require('dap')
local dapui = require('dapui')

local mason = vim.fn.stdpath('data') .. '/mason'

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------
dapui.setup({
  -- Single sidebar + a repl/console tray. The vimspector default layout had
  -- roughly this shape, and it survives a narrow ssh terminal better than the
  -- two-sidebar arrangement dap-ui ships with.
  layouts = {
    {
      position = 'left',
      size = 40,
      elements = {
        { id = 'scopes',      size = 0.45 },
        { id = 'stacks',      size = 0.25 },
        { id = 'watches',     size = 0.15 },
        { id = 'breakpoints', size = 0.15 },
      },
    },
    {
      position = 'bottom',
      size = 10,
      elements = {
        { id = 'repl',    size = 0.5 },
        { id = 'console', size = 0.5 },
      },
    },
  },
})

require('nvim-dap-virtual-text').setup({
  -- Only annotate frames you are actually stopped in; annotating every frame
  -- turns a deep stack into noise.
  only_first_definition = true,
  all_references = false,
})

-- Open the UI when a session really starts, tear it down when it ends.
-- `after` hooks fire once the adapter has replied, so the UI never flashes up
-- for a session that failed to launch.
dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui'] = function() dapui.close() end

-- Letter signs, matching the diagnostics style in lsp.lua rather than pulling
-- in a nerd-font dependency.
vim.fn.sign_define('DapBreakpoint',          { text = 'B', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '?', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DapLogPoint',            { text = 'L', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DapStopped',             { text = '>', texthl = 'DiagnosticSignWarn', linehl = 'Visual' })
vim.fn.sign_define('DapBreakpointRejected',  { text = 'x', texthl = 'DiagnosticSignHint' })

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Breakpoint navigation. vimspector had these as [b / ]b; nvim-dap has no
-- built-in jump, so walk its breakpoint list for the current buffer.
local function jump_breakpoint(dir)
  local bufnr = vim.api.nvim_get_current_buf()
  local bps = require('dap.breakpoints').get(bufnr)[bufnr] or {}
  if #bps == 0 then
    return
  end
  local lines = vim.tbl_map(function(bp) return bp.line end, bps)
  table.sort(lines)
  local cur = vim.fn.line('.')
  local target
  if dir > 0 then
    for _, l in ipairs(lines) do
      if l > cur then target = l break end
    end
    target = target or lines[1] -- wrap
  else
    for i = #lines, 1, -1 do
      if lines[i] < cur then target = lines[i] break end
    end
    target = target or lines[#lines] -- wrap
  end
  vim.api.nvim_win_set_cursor(0, { target, 0 })
end

map('n', '[b', function() jump_breakpoint(-1) end, 'Prev breakpoint')
map('n', ']b', function() jump_breakpoint(1)  end, 'Next breakpoint')

-- Flow control
map('n', '<localleader>dG',  dap.continue,      'Debug continue/start')
map('n', '<localleader>dgg', function() dap.restart() end, 'Debug restart')
map('n', '<localleader>dp',  dap.pause,         'Debug pause')
map('n', '<localleader>dq',  function() dap.terminate() dapui.close() end, 'Debug stop')
map('n', '<localleader>dl',  dap.step_over,     'Debug step over')
map('n', '<localleader>dj',  dap.step_into,     'Debug step into')
map('n', '<localleader>dk',  dap.step_out,      'Debug step out')
map('n', '<localleader>dL',  dap.run_to_cursor, 'Debug run to cursor')

-- Breakpoints. <localleader>d? took a condition under vimspector too.
map('n', '<localleader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('n', '<localleader>d?', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, 'Conditional breakpoint')
map('n', '<localleader>dB', function() dap.list_breakpoints(true) end, 'List breakpoints')

-- Frames. `,dh` and <localleader>h both jumped to the program counter before;
-- dap.focus_frame() is the direct equivalent.
map('n', '<localleader>do', dap.up,          'Up one frame')
map('n', '<localleader>di', dap.down,        'Down one frame')
map('n', '<localleader>df', dap.focus_frame, 'Jump to current frame')
map('n', '<localleader>h',  dap.focus_frame, 'Jump to current frame')
map('n', ',dh',             dap.focus_frame, 'Jump to current frame')

-- Inspect. vimspector's BalloonEval, on both normal and visual.
map({ 'n', 'x' }, '<localleader>dd', function() dapui.eval() end, 'Evaluate expression')
map('n', '<localleader>du', function() dapui.toggle() end, 'Toggle debugger UI')
map('n', '<localleader>dr', function() dap.repl.toggle() end, 'Toggle debug REPL')

-- The VISUAL_STUDIO function keys that g:vimspector_enable_mappings used to
-- install.
map('n', '<F5>',   dap.continue,          'Debug continue/start')
map('n', '<S-F5>', function() dap.terminate() dapui.close() end, 'Debug stop')
map('n', '<C-S-F5>', function() dap.restart() end, 'Debug restart')
map('n', '<F6>',   dap.pause,             'Debug pause')
map('n', '<F9>',   dap.toggle_breakpoint, 'Toggle breakpoint')
map('n', '<S-F9>', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, 'Conditional breakpoint')
map('n', '<F10>',   dap.step_over, 'Debug step over')
map('n', '<F11>',   dap.step_into, 'Debug step into')
map('n', '<S-F11>', dap.step_out,  'Debug step out')

--------------------------------------------------------------------------------
-- Adapters
--------------------------------------------------------------------------------
-- Java is deliberately absent: jdt.ls owns its debug adapter (it runs as a
-- server plugin, not a standalone binary), so nvim-jdtls registers it at
-- attach time. See config/java.lua.

local function executable(path)
  return vim.fn.executable(path) == 1
end

-- Rust / C / C++ via codelldb (:MasonInstall codelldb).
local codelldb = mason .. '/bin/codelldb'
if executable(codelldb) then
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb,
      args = { '--port', '${port}' },
    },
  }

  local function pick_binary()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end

  local codelldb_config = {
    {
      name = 'Launch',
      type = 'codelldb',
      request = 'launch',
      program = pick_binary,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
  dap.configurations.rust = codelldb_config
  dap.configurations.c = codelldb_config
  dap.configurations.cpp = codelldb_config
end

-- Python via debugpy (:MasonInstall debugpy). Mason installs it into a venv,
-- so the adapter runs that venv's interpreter, while `pythonPath` below
-- resolves the interpreter the *code* should run under.
local debugpy = mason .. '/packages/debugpy/venv/bin/python'
if executable(debugpy) then
  dap.adapters.python = {
    type = 'executable',
    command = debugpy,
    args = { '-m', 'debugpy.adapter' },
  }
  dap.configurations.python = {
    {
      name = 'Launch file',
      type = 'python',
      request = 'launch',
      program = '${file}',
      cwd = '${workspaceFolder}',
      pythonPath = function()
        -- Prefer an activated virtualenv, then a local .venv, then whatever
        -- python3 is on PATH.
        local venv = os.getenv('VIRTUAL_ENV')
        if venv then
          return venv .. '/bin/python'
        end
        local local_venv = vim.fn.getcwd() .. '/.venv/bin/python'
        if executable(local_venv) then
          return local_venv
        end
        return 'python3'
      end,
    },
  }
end
