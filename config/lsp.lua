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
-- Treesitter (classic `master` API; needs a C compiler on PATH, e.g. zig)
--------------------------------------------------------------------------------
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline',
    'bash', 'c', 'json', 'python', 'rust', 'javascript', 'typescript',
    'php', 'haskell', 'java',
  },
  auto_install = true, -- compile parsers on demand (requires a compiler)
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        ['io'] = '@class.inner',
        ['ao'] = '@class.outer',
      },
    },
  },
})
