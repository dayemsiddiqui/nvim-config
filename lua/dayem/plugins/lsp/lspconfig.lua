return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local lsp_utils = require("dayem.utils.lsp")

    lsp_utils.setup_diagnostics()

    local capabilities = lsp_utils.get_capabilities()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        lsp_utils.on_attach(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
      end,
    })

    local servers = {
      lua_ls = {
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
      },

      ts_ls = {
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
      },

      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },

      intelephense = {
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
            },
          },
        },
      },

      rust_analyzer = {
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
      },

      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    }

    for server, config in pairs(servers) do
      config.capabilities = capabilities
      lspconfig[server].setup(config)
    end

    local default_servers = {
      "html", "cssls", "tailwindcss", "jsonls", "yamlls",
      "bashls", "dockerls", "graphql", "marksman", "prismals",
    }

    for _, server in ipairs(default_servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
      })
    end
  end,
}
