-- Java: jdt.ls via nvim-jdtls.
-- Loaded from lspConfig.vim under `if has('nvim')`.
--
-- Why this is not just another entry in lsp.lua's mason-lspconfig list:
-- jdt.ls is the same server VSCode's Red Hat Java extension runs, and a large
-- part of what makes that extension feel like an IDE is *not* in the LSP spec.
-- Class files behind `jdt://` URIs, extract/generate refactorings and test
-- discovery are all custom requests a generic client cannot know about, so
-- nvim-jdtls starts and owns the client instead of vim.lsp.enable().
-- Consequently jdtls is excluded from automatic_enable in lsp.lua -- otherwise
-- two clients attach to every Java buffer.
--
-- Everything below is installed through mason:
--   :MasonInstall jdtls java-debug-adapter java-test
-- jdtls ships lombok.jar itself, but -- unlike VSCode, which enables Lombok by
-- default -- nothing adds the javaagent for you. That omission is what makes a
-- stock jdtls install look broken on any Lombok project: every generated
-- getter, setter and builder is reported as an undefined method.

local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

local mason = vim.fn.stdpath('data') .. '/mason'
local launcher = mason .. '/bin/jdtls'

-- Warn once rather than on every Java buffer.
local warned = false
local function missing_server()
  if vim.fn.executable(launcher) == 1 then
    return false
  end
  if not warned then
    warned = true
    vim.schedule(function()
      vim.notify(
        'jdtls not installed (:MasonInstall jdtls java-debug-adapter java-test)',
        vim.log.levels.WARN
      )
    end)
  end
  return true
end

--------------------------------------------------------------------------------
-- Bundles: debug + test, loaded into the server's OSGi container
--------------------------------------------------------------------------------
-- java-debug is not a standalone debug adapter -- it runs *inside* jdt.ls, so
-- the debugger only exists once these jars are handed to the server at
-- startup. That is why config/dap.lua defines no java adapter.
local function bundles()
  local jars = {}
  local seen = {}

  -- mason ships both a versioned jar and an unversioned symlink to it, so a
  -- naive glob would hand the same bundle to the server twice. Dedupe on the
  -- resolved path.
  local function add(path)
    local real = vim.uv.fs_realpath(path) or path
    if not seen[real] then
      seen[real] = true
      table.insert(jars, real)
    end
  end

  for _, jar in ipairs(vim.fn.glob(mason .. '/share/java-debug-adapter/*.jar', true, true)) do
    add(jar)
  end

  -- The test runner and the coverage agent are launched as separate processes
  -- by the test plugin; loading them as bundles breaks the server.
  local excluded = {
    ['com.microsoft.java.test.runner-jar-with-dependencies.jar'] = true,
    ['jacocoagent.jar'] = true,
  }
  for _, jar in ipairs(vim.fn.glob(mason .. '/share/java-test/*.jar', true, true)) do
    if not excluded[vim.fn.fnamemodify(jar, ':t')] then
      add(jar)
    end
  end

  return jars
end

--------------------------------------------------------------------------------
-- Installed JDKs
--------------------------------------------------------------------------------
-- jdt.ls itself runs on whatever java is on PATH (21+ required), but a project
-- targeting an older release needs a matching JDK registered here, otherwise
-- you get bogus errors about the language level. Probes the usual system
-- locations so a newly apt-installed JDK is picked up without editing this.
local function runtimes()
  local found = {}
  for _, dir in ipairs({ '/usr/lib/jvm', vim.fn.expand('~/.sdkman/candidates/java') }) do
    for _, path in ipairs(vim.fn.glob(dir .. '/*', true, true)) do
      -- Only real directories: /usr/lib/jvm is full of symlinked aliases that
      -- would register the same JDK several times under different names.
      if vim.fn.isdirectory(path) == 1 and vim.uv.fs_realpath(path) == path then
        local version = path:match('java%-(%d+)') or path:match('jdk%-?(%d+)') or path:match('^.*/(%d+)%.')
        if version and vim.fn.executable(path .. '/bin/java') == 1 then
          local name = 'JavaSE-' .. version
          if not found[name] then
            found[name] = { name = name, path = path }
          end
        end
      end
    end
  end
  return vim.tbl_values(found)
end

--------------------------------------------------------------------------------
-- Java-specific keymaps
--------------------------------------------------------------------------------
-- The generic LSP maps (gd, gr, K, <localleader>r/a/f, ...) come from the
-- LspAttach autocmd in lsp.lua, which fires for this client too. Only the
-- jdt.ls extensions that have no vim.lsp.buf equivalent are bound here.
local function keymaps(buf)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
  end

  map('n', '<localleader>jo', jdtls.organize_imports, 'Java organize imports')
  map('n', '<localleader>jv', jdtls.extract_variable, 'Java extract variable')
  map('x', '<localleader>jv', function() jdtls.extract_variable(true) end, 'Java extract variable')
  map('n', '<localleader>jc', jdtls.extract_constant, 'Java extract constant')
  map('x', '<localleader>jc', function() jdtls.extract_constant(true) end, 'Java extract constant')
  map('x', '<localleader>jm', function() jdtls.extract_method(true) end, 'Java extract method')

  -- Run/debug the test under the cursor, or the whole class. This is the
  -- payoff for loading the java-test bundles.
  map('n', '<localleader>jt', jdtls.test_nearest_method, 'Java test nearest method')
  map('n', '<localleader>jT', jdtls.test_class,          'Java test class')

  map('n', '<localleader>ju', jdtls.update_projects_config, 'Java reload project config')
end

--------------------------------------------------------------------------------
-- Start
--------------------------------------------------------------------------------
-- ~/vimfiles is not in 'runtimepath' (only ~/vimfiles/plugged/* is), so the
-- usual ftplugin/java.lua would never be sourced. A FileType autocmd is the
-- equivalent, and matches how the rest of this config is wired anyway.
local function start()
  if missing_server() then
    return
  end

  local buf = vim.api.nvim_get_current_buf()

  -- Two tiers, as nvim-lspconfig does it: prefer a wrapper/settings file or
  -- the git root, because in a multi-module Maven build the nearest pom.xml is
  -- the submodule's, and rooting there hides the rest of the project.
  local root = vim.fs.root(buf, { 'gradlew', 'mvnw', 'settings.gradle', 'settings.gradle.kts', '.git' })
    or vim.fs.root(buf, { 'pom.xml', 'build.gradle', 'build.gradle.kts', 'build.xml' })
  if not root then
    return
  end

  -- Per-project workspace. Sharing one -data directory across projects makes
  -- jdt.ls reindex on every switch; the mason launcher passes
  -- -Dosgi.configuration.cascaded=true, so the per-instance OSGi config lands
  -- in here as well and concurrent nvim instances stay out of each other's way.
  local workspace = vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.fnamemodify(root, ':p:h:t')

  local extendedClientCapabilities = vim.deepcopy(jdtls.extendedClientCapabilities)
  -- Lets the server send the rest of an import's edits after a completion is
  -- accepted, instead of resolving every candidate up front.
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  jdtls.start_or_attach({
    name = 'jdtls',
    cmd = {
      launcher,
      '-data', workspace,
      -- The missing piece. mason installs lombok.jar next to the server but
      -- its launcher never references it.
      '--jvm-arg=-javaagent:' .. mason .. '/share/jdtls/lombok.jar',
    },
    root_dir = root,
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    init_options = {
      bundles = bundles(),
      extendedClientCapabilities = extendedClientCapabilities,
    },
    settings = {
      java = {
        configuration = {
          -- Silences the "would you like to configure runtimes" prompt and
          -- fixes language-level diagnostics on projects not targeting the
          -- JDK jdt.ls itself runs on.
          runtimes = runtimes(),
          updateBuildConfiguration = 'interactive',
        },
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        -- Decompile with the bundled decompiler so `gd` into a dependency
        -- without sources still lands on something readable.
        contentProvider = { preferred = 'fernflower' },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        inlayHints = { parameterNames = { enabled = 'all' } },
        format = { enabled = true },
        signatureHelp = { enabled = true },
        completion = {
          -- Without these, static imports like assertThat never surface in
          -- completion, which makes test files painful.
          favoriteStaticMembers = {
            'org.junit.jupiter.api.Assertions.*',
            'org.junit.jupiter.api.Assumptions.*',
            'org.junit.Assert.*',
            'org.junit.Assume.*',
            'org.mockito.Mockito.*',
            'org.mockito.ArgumentMatchers.*',
            'org.assertj.core.api.Assertions.*',
            'java.util.Objects.requireNonNull',
            'java.util.Objects.requireNonNullElse',
          },
          -- Internal/shaded packages that are almost never what you meant.
          filteredTypes = {
            'com.sun.*',
            'io.micrometer.shaded.*',
            'java.awt.*',
            'jdk.*',
            'sun.*',
          },
        },
        sources = {
          organizeImports = {
            -- Eclipse's defaults (99) effectively never collapse to a
            -- wildcard; these match what most Java projects actually use.
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
      },
    },
    on_attach = function(_, bufnr)
      keymaps(bufnr)
      -- Registers the java adapter with nvim-dap and discovers main classes so
      -- <F5> offers "run this application" without a hand-written config.
      jdtls.setup_dap({ hotcodereplace = 'auto' })
      require('jdtls.dap').setup_dap_main_class_configs()
    end,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserJdtls', {}),
  pattern = 'java',
  callback = start,
})
