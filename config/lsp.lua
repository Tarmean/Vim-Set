-- Native LSP + completion + treesitter setup (replaces coc.nvim).
-- Loaded from lspConfig.vim under `if has('nvim')`.

--------------------------------------------------------------------------------
-- Completion: blink.cmp
--------------------------------------------------------------------------------
require('blink.cmp').setup({
  -- Keymap mirrors the old coc bindings: <cr> confirms, <tab>/<s-tab>
  -- navigate the menu, <c-space> triggers, <c-j> jumps snippet placeholders.
  keymap = {
    preset = 'enter',
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-j>'] = { 'snippet_forward', 'fallback' },
    ['<C-k>'] = { 'snippet_backward', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  signature = { enabled = true },
  completion = { documentation = { auto_show = true } },
  -- Uses the prebuilt Rust fuzzy binary (downloaded on the v1.* tag); falls
  -- back to the pure-Lua matcher with a warning if the binary is missing.
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})

--------------------------------------------------------------------------------
-- LSP servers via mason
--------------------------------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup({
  -- Low-friction servers auto-installed on startup. Heavier ones that need an
  -- external toolchain are installed manually (:MasonInstall ...) and then
  -- auto-enabled by automatic_enable:
  --   * hls     -> install via ghcup / matching GHC, or :MasonInstall haskell-language-server
  --   * jdtls   -> :MasonInstall jdtls  (nvim-jdtls recommended for full features)
  ensure_installed = {
    'lua_ls',
    'jsonls',
    'ts_ls',
    'basedpyright',
    'rust_analyzer',
    'intelephense',
  },
  -- automatic_enable is true by default: installed servers are enabled via
  -- vim.lsp.enable() with the native vim.lsp.config() mechanism (nvim 0.11+).
})

-- Give every server blink's completion capabilities.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Per-server tweaks (root detection ported from the old coc_root_patterns).
vim.lsp.config('intelephense', {
  root_markers = { 'composer.json', '.git', '.env' },
})
vim.lsp.config('hls', {
  root_markers = { 'stack.yaml', 'cabal.project', '*.cabal', '.git' },
})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
    },
  },
})

--------------------------------------------------------------------------------
-- Diagnostics UX
--------------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN]  = 'W',
      [vim.diagnostic.severity.INFO]  = 'I',
      [vim.diagnostic.severity.HINT]  = 'H',
    },
  },
})

--------------------------------------------------------------------------------
-- Keymaps (buffer-local, attached when a server connects)
--------------------------------------------------------------------------------
local function hover_or_help()
  if vim.bo.filetype == 'help' then
    vim.cmd('help ' .. vim.fn.expand('<cword>'))
  else
    vim.lsp.buf.hover()
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', {}),
  callback = function(args)
    local buf = args.buf
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
    end

    -- gotos
    map('n', 'gd', vim.lsp.buf.definition,       'LSP definition')
    map('n', 'gu', vim.lsp.buf.declaration,      'LSP declaration')
    map('n', 'gy', vim.lsp.buf.type_definition,  'LSP type definition')
    map('n', 'gi', vim.lsp.buf.implementation,   'LSP implementation')
    map('n', 'gr', vim.lsp.buf.references,       'LSP references')
    map('n', 'gR', vim.lsp.buf.references,       'LSP references')

    -- docs
    map('n', 'K',  hover_or_help, 'Hover / help')
    map('n', 'gh', hover_or_help, 'Hover / help')
    map('n', 'gK', vim.diagnostic.open_float, 'Line diagnostics')

    -- refactor / actions / format
    map('n', '<localleader>r', vim.lsp.buf.rename,      'LSP rename')
    map({ 'n', 'x' }, '<localleader>a', vim.lsp.buf.code_action, 'LSP code action')
    map({ 'n', 'x' }, '<Tab>',          vim.lsp.buf.code_action, 'LSP code action')
    map({ 'n', 'x' }, '<localleader>f', function() vim.lsp.buf.format({ async = true }) end, 'LSP format')
    map({ 'n', 'x' }, '<S-Tab>',        vim.lsp.codelens.run, 'Run codelens')

    -- diagnostics navigation (ported from coc-diagnostic-prev/next)
    map('n', '<c-k>', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev diagnostic')
    map('n', '<c-j>', function() vim.diagnostic.jump({ count =  1, float = true }) end, 'Next diagnostic')
    map('n', '[c',    function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev diagnostic')
    map('n', ']c',    function() vim.diagnostic.jump({ count =  1, float = true }) end, 'Next diagnostic')

    -- lists / symbols
    map('n', '<leader>d', vim.diagnostic.setloclist,     'Diagnostics list')
    map('n', '<leader>s', vim.lsp.buf.document_symbol,   'Document symbols')
    map('n', '<leader>S', vim.lsp.buf.workspace_symbol,  'Workspace symbols')

    -- document highlight on CursorHold (coc did this via CocActionAsync('highlight'))
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight') then
      local hl = vim.api.nvim_create_augroup('UserLspHighlight_' .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl, buffer = buf, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = hl, buffer = buf, callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- :Format and :OR (organize imports), ported from the old coc commands.
vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {})
vim.api.nvim_create_user_command('OR', function()
  vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
end, {})

--------------------------------------------------------------------------------
-- Treesitter (`main` branch API -- `nvim-treesitter.configs` no longer exists)
--------------------------------------------------------------------------------
-- The rewrite dropped the module system: highlight/indent are just
-- vim.treesitter.start() + indentexpr, and parsers are installed explicitly
-- rather than via ensure_installed. Requires the tree-sitter CLI (>= 0.26.1,
-- `npm i -g tree-sitter-cli`) plus a C compiler.
local ts = require('nvim-treesitter')

-- This is the default location; spelled out because that is where :TSEnsure
-- drops parsers and queries. Note that `:checkhealth nvim-treesitter` claims
-- it "is not in runtimepath" on Windows -- a false positive: the directory is
-- in 'runtimepath', but with backslashes, and the check string-compares it
-- against its own forward-slash copy.
ts.setup({ install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site') })

-- Installed lazily on first use, see the FileType autocmd below. :TSEnsure
-- compiles the whole list up front. Parsers nvim already ships (c, lua,
-- markdown, query, vim, vimdoc) are skipped automatically.
local ts_langs = {
  'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline',
  'bash', 'c', 'json', 'yaml', 'python', 'rust', 'javascript', 'typescript',
  'php', 'haskell', 'java',
}

-- The tree-sitter CLI compiles parsers with cl.exe on Windows. There is no
-- MSVC on this box, so fall back to zig (clang underneath) through the shims
-- in ~/vimfiles/bin -- they are named gcc/g++ so the CLI emits GNU-style
-- flags, and they append a target triple zig accepts. Only applied while an
-- install is running, so builds started from :terminal keep the real
-- compiler (a forced mingw target would break e.g. cargo).
--
-- Nil everywhere else: on unix the CLI already picks up cc/c++ from a normal
-- toolchain (`apt install build-essential`), so nothing needs overriding.
local ts_cc = (function()
  if vim.fn.has('win32') == 0 or vim.env.CC or vim.fn.executable('zig') == 0 then
    return nil
  end
  for _, cc in ipairs({ 'cc', 'gcc', 'clang', 'cl' }) do
    if vim.fn.executable(cc) == 1 then
      return nil
    end
  end
  local bin = vim.fn.expand('~/vimfiles/bin')
  return { CC = bin .. '/gcc.cmd', CXX = bin .. '/g++.cmd' }
end)()

-- Depth-counted so overlapping installs (:TSEnsure while a FileType-triggered
-- one is still running) restore the original values, not the shims.
local ts_cc_depth, ts_cc_saved = 0, nil

local function ts_cc_push()
  if not ts_cc then
    return
  end
  if ts_cc_depth == 0 then
    ts_cc_saved = { CC = vim.env.CC, CXX = vim.env.CXX }
    vim.env.CC, vim.env.CXX = ts_cc.CC, ts_cc.CXX
  end
  ts_cc_depth = ts_cc_depth + 1
end

local function ts_cc_pop()
  if not ts_cc then
    return
  end
  ts_cc_depth = ts_cc_depth - 1
  if ts_cc_depth == 0 then
    vim.env.CC, vim.env.CXX = ts_cc_saved.CC, ts_cc_saved.CXX
  end
end

local ts_pending = {} ---@type table<string, boolean>

--- The plugin shells out to `tree-sitter generate/build` and only reports the
--- failure per-parser, which the FileType hook below would then retry for
--- every buffer. Warn once and stay quiet instead -- mainly a fresh-machine
--- concern, e.g. a Linux VM without `npm i -g tree-sitter-cli` yet.
local ts_warned = false
local function ts_cli_missing()
  if vim.fn.executable('tree-sitter') == 1 then
    return false
  end
  if not ts_warned then
    ts_warned = true
    vim.schedule(function()
      vim.notify(
        'tree-sitter CLI not found; parsers will not be installed '
          .. '(npm i -g tree-sitter-cli, or cargo install tree-sitter-cli)',
        vim.log.levels.WARN
      )
    end)
  end
  return true
end

--- Is a parser already loadable (bundled with nvim, or previously installed)?
--- language.add() reports a missing parser by returning nil, not by raising.
---@param lang string
---@return boolean
local function ts_available(lang)
  local ok, loaded = pcall(vim.treesitter.language.add, lang)
  return ok and loaded == true
end

--- Install parsers, restoring CC/CXX once the async job finishes.
---@param langs string[]
---@param on_done? fun()
local function ts_install(langs, on_done)
  langs = vim.tbl_filter(function(lang)
    return not ts_pending[lang] and not ts_available(lang)
  end, langs)
  if #langs == 0 or ts_cli_missing() then
    return
  end

  ts_cc_push()
  for _, lang in ipairs(langs) do
    ts_pending[lang] = true
  end

  -- max_jobs defaults to 100. The zig/clang shims need ~1GB for the bigger
  -- generated parsers (rust, java, yaml), so the default reliably OOMs there;
  -- a stock unix toolchain handles the default fine, so only throttle when
  -- the shims are in play.
  local max_jobs = ts_cc and 2 or nil
  ts.install(langs, { summary = true, max_jobs = max_jobs }):await(function()
    for _, lang in ipairs(langs) do
      ts_pending[lang] = nil
    end
    ts_cc_pop()
    if on_done then
      vim.schedule(on_done)
    end
  end)
end

vim.api.nvim_create_user_command('TSEnsure', function()
  ts_install(ts_langs)
end, { desc = 'Install the missing parsers this config expects' })

local function ts_attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) or not pcall(vim.treesitter.start, buf, lang) then
    return
  end
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserTreesitter', {}),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then
      return
    end
    if ts_available(lang) then
      ts_attach(args.buf, lang)
    elseif vim.list_contains(ts_langs, lang) then
      -- Replaces the old `auto_install`: compile on first sight, then attach.
      ts_install({ lang }, function()
        ts_attach(args.buf, lang)
      end)
    end
  end,
})

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
})
for lhs, query in pairs({
  ['if'] = '@function.inner',
  ['af'] = '@function.outer',
  ['io'] = '@class.inner',
  ['ao'] = '@class.outer',
}) do
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
  end, { silent = true, desc = 'Select ' .. query })
end
