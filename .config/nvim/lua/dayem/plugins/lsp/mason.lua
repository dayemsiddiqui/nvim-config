return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "gopls",
        "rust_analyzer",
        "pyright",
        "intelephense",
        "lua_ls",
        "jsonls",
        "yamlls",
        "bashls",
        "dockerls",
        "graphql",
        "marksman",
        "prismals",
        "terraformls",
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettierd",
        "stylua",
        "gofumpt",
        "goimports",
        "pint",
        "eslint_d",
        "golangci-lint",
        "ruff",
        "phpstan",
      },
      auto_update = false,
      run_on_start = false,
    })
  end,
}
