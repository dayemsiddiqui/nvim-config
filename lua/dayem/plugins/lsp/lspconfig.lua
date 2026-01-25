return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lsp_utils = require("dayem.utils.lsp")

    lsp_utils.setup_diagnostics()

    local capabilities = lsp_utils.get_capabilities()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_clients({ id = ev.data.client_id })[1]
        lsp_utils.on_attach(client, ev.buf)
      end,
    })

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config('ts_ls', {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
      root_markers = { 'package.json', 'tsconfig.json', '.git' },
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    })

    vim.lsp.config('gopls', {
      cmd = { 'gopls' },
      filetypes = { 'go' },
      root_markers = { 'go.mod', '.git' },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
            unusedwrite = true,
            useany = true,
          },
          staticcheck = true,
          gofumpt = true,
          semanticTokens = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    vim.lsp.config('intelephense', {
      cmd = { 'intelephense', '--stdio' },
      filetypes = { 'php', 'blade' },
      root_markers = { 'composer.json', '.git' },
      settings = {
        intelephense = {
          stubs = {
            "bcmath", "bz2", "calendar", "Core", "curl", "date", "dba", "dom", "enchant",
            "fileinfo", "filter", "ftp", "gd", "gettext", "hash", "iconv", "imap", "intl",
            "json", "ldap", "libxml", "mbstring", "mcrypt", "mysql", "mysqli", "password",
            "pcntl", "pcre", "PDO", "pdo_mysql", "Phar", "readline", "recode", "Reflection",
            "regex", "session", "SimpleXML", "soap", "sockets", "sodium", "SPL", "standard",
            "superglobals", "sysvsem", "sysvshm", "tokenizer", "xml", "xdebug", "xmlreader",
            "xmlwriter", "yaml", "zip", "zlib", "wordpress", "phpunit", "laravel",
          },
          files = {
            maxSize = 5000000,
            associations = {
              "*.php",
              "*.blade.php",
            },
          },
          format = {
            enable = true,
          },
          completion = {
            insertUseDeclaration = true,
            fullyQualifyGlobalConstantsAndFunctions = false,
            triggerParameterHints = true,
            maxItems = 100,
          },
          diagnostics = {
            enable = true,
            run = "onSave",
            undefinedTypes = true,
            undefinedFunctions = true,
            undefinedConstants = true,
            undefinedProperties = true,
            undefinedMethods = true,
          },
          telemetry = {
            enabled = false,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all",
              suppressNameMatchingValue = true,
            },
            typeHints = {
              enabled = true,
            },
          },
        },
      },
    })

    vim.lsp.config('rust_analyzer', {
      cmd = { 'rust-analyzer' },
      filetypes = { 'rust' },
      root_markers = { 'Cargo.toml', '.git' },
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    })

    vim.lsp.config('pyright', {
      cmd = { 'pyright-langserver', '--stdio' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'setup.py', '.git' },
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    vim.lsp.config('html', {
      cmd = { 'vscode-html-language-server', '--stdio' },
      filetypes = { 'html' },
      root_markers = { 'package.json', '.git' },
    })

    vim.lsp.config('cssls', {
      cmd = { 'vscode-css-language-server', '--stdio' },
      filetypes = { 'css', 'scss', 'less' },
      root_markers = { 'package.json', '.git' },
    })

    vim.lsp.config('tailwindcss', {
      cmd = { 'tailwindcss-language-server', '--stdio' },
      filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
      root_markers = { 'tailwind.config.js', 'tailwind.config.ts', '.git' },
    })

    vim.lsp.config('jsonls', {
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      root_markers = { '.git' },
    })

    vim.lsp.config('yamlls', {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml', 'yaml.docker-compose' },
      root_markers = { '.git' },
    })

    vim.lsp.config('bashls', {
      cmd = { 'bash-language-server', 'start' },
      filetypes = { 'sh', 'bash' },
      root_markers = { '.git' },
    })

    vim.lsp.config('dockerls', {
      cmd = { 'docker-langserver', '--stdio' },
      filetypes = { 'dockerfile' },
      root_markers = { '.git' },
    })

    vim.lsp.config('graphql', {
      cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
      filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
      root_markers = { '.graphqlrc', '.graphql.config.js', 'package.json', '.git' },
    })

    vim.lsp.config('marksman', {
      cmd = { 'marksman', 'server' },
      filetypes = { 'markdown' },
      root_markers = { '.git' },
    })

    vim.lsp.config('prismals', {
      cmd = { 'prisma-language-server', '--stdio' },
      filetypes = { 'prisma' },
      root_markers = { 'package.json', '.git' },
    })
  end,
}
