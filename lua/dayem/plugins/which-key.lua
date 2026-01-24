return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")

    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      layout = {
        spacing = 3,
      },
    })

    wk.add({
      { "<leader>c", group = "Code" },
      { "<leader>ca", desc = "Code Actions" },
      { "<leader>cr", desc = "Rename Symbol" },
      { "<leader>cd", desc = "Show Diagnostic" },
      { "<leader>cl", desc = "LSP Info" },
      { "<leader>cR", desc = "Restart LSP" },

      { "<leader>e", desc = "Explorer (Neo-tree)" },
      { "<leader>f", desc = "Format Buffer" },
      { "<leader>fp", desc = "Copy Filepath" },

      { "<leader>s", group = "Split" },
      { "<leader>sv", desc = "Vertical Split" },
      { "<leader>sh", desc = "Horizontal Split" },
      { "<leader>se", desc = "Equal Split Size" },
      { "<leader>sx", desc = "Close Split" },
      { "<leader>sn", desc = "Next Split" },
      { "<leader>sp", desc = "Previous Split" },
      { "<leader>s", desc = "Replace Word Globally", mode = "n" },

      { "<leader>t", group = "Tabs/Buffers" },
      { "<leader>to", desc = "Open New Tab" },
      { "<leader>tx", desc = "Close Buffer" },
      { "<leader>tn", desc = "Next Buffer" },
      { "<leader>tp", desc = "Previous Buffer" },
      { "<leader>tf", desc = "Open Current File in New Tab" },

      { "<leader>gh", group = "GitHub" },
      { "<leader>gha", desc = "Switch Account" },
      { "<leader>ghs", desc = "Show Account Status" },
      { "<leader>ght", desc = "Toggle Auto-Switch" },
      { "<leader>ghr", desc = "Register Project" },
      { "<leader>ghu", desc = "Unregister Project" },

      { "<leader>l", group = "Laravel" },
      { "<leader>la", desc = "Artisan Commands" },
      { "<leader>lr", desc = "Routes" },
      { "<leader>lm", desc = "Related Files" },

      { "<leader>p", group = "PHP" },
      { "<leader>pm", desc = "Create Method" },
      { "<leader>pc", desc = "Create Class" },
      { "<leader>pg", desc = "Getters/Setters" },
      { "<leader>pn", desc = "Add Namespace" },
      { "<leader>pt", desc = "Run Test" },

      { "<leader>pa", group = "PhpActor" },
      { "<leader>paa", desc = "Context Menu" },
      { "<leader>pan", desc = "New Class" },
      { "<leader>pae", desc = "Extract Method", mode = "v" },
      { "<leader>pai", desc = "Import Class" },
      { "<leader>par", desc = "Rename" },

      { "<leader>Y", desc = "Yazi File Manager" },

      { "g", group = "Go to" },
      { "gd", desc = "Go to Definition" },
      { "gD", desc = "Go to Declaration" },
      { "gr", desc = "Show References" },
      { "gi", desc = "Go to Implementation" },
      { "gt", desc = "Go to Type Definition" },

      { "]", group = "Next" },
      { "]d", desc = "Next Diagnostic" },

      { "[", group = "Previous" },
      { "[d", desc = "Previous Diagnostic" },

      { "K", desc = "Hover Documentation", mode = "n" },
    })
  end,
}
