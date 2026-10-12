-- Fuzzy symbol navigation, the two IDE features that native LSP leaves as a
-- quickfix dump: "what is defined in this file" and "where is X defined in the
-- project".
--
--   <leader>s   symbols in the current file
--   <leader>S   symbols in the project
--
-- Both degrade in tiers so they still work in an ssh session on a box with no
-- language server installed:
--
--   <leader>s   LSP documentSymbol -> treesitter locals -> rg over the file
--   <leader>S   LSP workspace/symbol (live) -> rg over the project
--
-- Every tier lists definitions only, never call sites or comments: the LSP and
-- treesitter tiers are definition-only by construction, and the rg tier keys
-- off declaration syntax rather than off the name (see def_pattern).

local fzf = require('fzf-lua')

fzf.setup({
  -- 'flex' drops the preview below the list instead of beside it once the
  -- window is too narrow to split, which is the usual case in an ssh terminal.
  winopts = { preview = { layout = 'flex' } },
})

--------------------------------------------------------------------------------
-- rg fallback
--------------------------------------------------------------------------------
-- Matching `foo(` would drag in every call site, so this is keyword driven:
-- it looks for the syntax that introduces a name, not for the name itself.
-- fzf then fuzzy-filters the (already definition-only) result set.

local def_modifiers = table.concat({
  'pub', 'public', 'private', 'protected', 'internal', 'export', 'default',
  'static', 'final', 'abstract', 'sealed', 'override', 'virtual', 'inline',
  'extern', 'unsafe', 'async', 'const', 'readonly', 'local',
}, '|')

local def_keywords = table.concat({
  'class', 'struct', 'enum', 'union', 'record', 'interface', 'trait', 'impl',
  'protocol', 'extension', 'module', 'namespace', 'package', 'object',
  'type', 'typedef', 'newtype', 'data', 'instance',
  'def', 'fn', 'fun', 'func', 'function', 'proc', 'sub', 'macro', 'macro_rules',
}, '|')

local def_pattern = table.concat({
  -- `def foo`, `pub async fn foo`, `private static final class Foo`,
  -- `function! Foo()` -- the `!?` is vimscript's bang.
  ([==[^\s*(?:(?:%s)\s+)*(?:%s)!?\s+[A-Za-z_]]==]):format(def_modifiers, def_keywords),
  -- `command! -bang -nargs=* Rg call ...`
  [==[^\s*com(?:m|ma|man|mand)?!?\s+(?:-\S+\s+)*[A-Za-z_]]==],
  -- `const foo = (x) => ...`, `foo := func() {`, `Foo = class ...`
  [==[^\s*(?:(?:const|let|var|export)\s+)*[A-Za-z_$][\w$]*\s*(?::=|=)\s*]==]
    .. [==[(?:async\s+)?(?:function|class|\(|[A-Za-z_$][\w$]*\s*=>)]==],
  -- Haskell/Idris/Agda top level type signature: `foo :: ...`
  [==[^[A-Za-z_][\w']*\s*::]==],
}, '|')

--- Project root, matching what Git_dir()/`:Rg` use elsewhere in this config:
--- the fugitive worktree, or the cwd outside a repo.
---@return string
local function project_root()
  local ok, root = pcall(vim.fn.FugitiveWorkTree)
  if ok and root ~= nil and root ~= '' then
    return root
  end
  return vim.uv.cwd()
end

--------------------------------------------------------------------------------
-- Symbol kind filter
--------------------------------------------------------------------------------
-- lua_ls (and it is not alone) reports every entry of a table literal as a
-- symbol, so a file with a couple of keyword lists answers documentSymbol with
-- a hundred [String]/[Object] rows and the eight real definitions are lost in
-- them. Drop the kinds that describe a value instead of introducing a name;
-- everything structural stays, private fields and methods included.
--
-- `:FzfLua lsp_document_symbols` still shows the unfiltered list.
local noise_kinds = {
  String = true, Number = true, Boolean = true, Array = true,
  Object = true, Key = true, Null = true,
  -- Package is here for lua_ls, which files every `if`/`else`/`for` block
  -- under it. The real users of the kind (a go package clause, a java package
  -- declaration) are one line at the top of the file and nothing anyone
  -- navigates to, so this is a cheap trade.
  Package = true,
}

-- entry.text is `[Kind] name`, indented by one level per nesting step, and the
-- filter runs before the kind gets replaced by its icon -- so match the first
-- bracket pair anywhere in the line rather than anchoring at the start.
local function drop_noise(entry)
  local kind = entry.text:match('%[(.-)%]')
  return not (kind and noise_kinds[kind])
end

-- In a data file the literals *are* the outline, so there the filter would
-- leave an empty list.
local data_filetypes = {
  json = true, jsonc = true, json5 = true, yaml = true, toml = true, xml = true,
}

--------------------------------------------------------------------------------
-- Pickers
--------------------------------------------------------------------------------

--- Does a server able to answer `method` cover this buffer?
---@param method string
---@return boolean
local function has_lsp(method)
  return #vim.lsp.get_clients({ bufnr = 0, method = method }) > 0
end

--- Is there a treesitter parser *and* a locals.scm for this buffer? Mirrors the
--- precondition fzf-lua's treesitter picker checks itself -- asking first is
--- what lets us fall through to rg instead of bailing with its message.
---
--- Note that nvim-treesitter ships locals.scm next to the parsers it installs,
--- so a language whose parser nvim already bundles (c, lua, markdown, query,
--- vim, vimdoc) never gets one and always lands on the rg tier.
---@return boolean
local function has_ts_locals()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  if not lang or not pcall(vim.treesitter.language.add, lang) then
    return false
  end
  return #vim.treesitter.query.get_files(lang, 'locals') > 0
end

local function document_symbols()
  if has_lsp('textDocument/documentSymbol') then
    fzf.lsp_document_symbols({
      regex_filter = not data_filetypes[vim.bo.filetype] and drop_noise or nil,
      winopts = { title = ' Symbols (lsp) ' },
    })
  elseif has_ts_locals() then
    fzf.treesitter({ winopts = { title = ' Symbols (treesitter) ' } })
  else
    fzf.grep_curbuf({
      search = def_pattern,
      no_esc = true,
      winopts = { title = ' Symbols (rg) ' },
    })
  end
end

local function workspace_symbols()
  if has_lsp('workspace/symbol') then
    -- Live: every keystroke is a new workspace/symbol request, so the server's
    -- own index does the searching and nothing is materialised up front.
    fzf.lsp_live_workspace_symbols({
      regex_filter = drop_noise,
      winopts = { title = ' Symbols (lsp) ' },
    })
  else
    fzf.grep({
      search = def_pattern,
      no_esc = true,
      cwd = project_root(),
      winopts = { title = ' Symbols (rg) ' },
    })
  end
end

vim.keymap.set('n', '<leader>s', document_symbols, { silent = true, desc = 'Fuzzy symbols in file' })
vim.keymap.set('n', '<leader>S', workspace_symbols, { silent = true, desc = 'Fuzzy symbols in project' })

vim.api.nvim_create_user_command('Symbols', document_symbols, { desc = 'Fuzzy symbols in file' })
vim.api.nvim_create_user_command('SymbolsProject', workspace_symbols, { desc = 'Fuzzy symbols in project' })
