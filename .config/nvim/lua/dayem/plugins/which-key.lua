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
      { "<leader>cf", desc = "Peek Function Definition" },
      { "<leader>cF", desc = "Peek Class Definition" },

      { "<leader>e", desc = "Explorer (Neo-tree)" },
      { "<leader>f", desc = "Format Buffer" },
      { "<leader>fp", desc = "Copy Filepath" },

      { "<leader>s", group = "Split/Swap" },
      { "<leader>sv", desc = "Vertical Split" },
      { "<leader>sh", desc = "Horizontal Split" },
      { "<leader>se", desc = "Equal Split Size" },
      { "<leader>sx", desc = "Close Split" },
      { "<leader>sn", desc = "Next Split" },
      { "<leader>sp", desc = "Previous Split" },
      { "<leader>sa", desc = "Swap Next Parameter" },
      { "<leader>sA", desc = "Swap Previous Parameter" },
      { "<leader>sf", desc = "Swap Next Function" },
      { "<leader>sF", desc = "Swap Previous Function" },
      { "<leader>s", desc = "Replace Word Globally", mode = "n" },

      { "<leader>t", group = "Tabs/Buffers" },
      { "<leader>to", desc = "Open New Tab" },
      { "<leader>tx", desc = "Close Buffer" },
      { "<leader>tn", desc = "Next Buffer" },
      { "<leader>tp", desc = "Previous Buffer" },
      { "<leader>tf", desc = "Open Current File in New Tab" },

      { "<leader>x", group = "Trouble/Diagnostics" },
      { "<leader>xx", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xs", desc = "Symbols (Trouble)" },
      { "<leader>xl", desc = "LSP Definitions/References (Trouble)" },
      { "<leader>xL", desc = "Location List (Trouble)" },
      { "<leader>xQ", desc = "Quickfix List (Trouble)" },

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

      { "<leader>ph", group = "PhpActor" },
      { "<leader>pha", desc = "Context Menu" },
      { "<leader>phn", desc = "New Class" },
      { "<leader>phe", desc = "Extract Method", mode = "v" },
      { "<leader>phi", desc = "Import Class" },
      { "<leader>phr", desc = "Rename" },

      { "<leader>r", group = "Run/Test" },
      { "<leader>rr", desc = "Run Nearest Test" },
      { "<leader>rf", desc = "Run All Tests in File" },
      { "<leader>rs", desc = "Run Entire Test Suite" },
      { "<leader>rl", desc = "Re-run Last Test" },
      { "<leader>rd", desc = "Debug Nearest Test" },
      { "<leader>ro", desc = "Show Test Output" },
      { "<leader>rS", desc = "Toggle Test Summary" },
      { "<leader>rw", desc = "Toggle Watch Mode" },
      { "<leader>rx", desc = "Stop Running Tests" },
      { "<leader>rp", desc = "Run Current Program" },
      { "<leader>rP", desc = "Run Program (Floating)" },
      { "<leader>ra", desc = "Smart Run (Auto-detect)" },
      { "<leader>rt", desc = "Toggle Test/Source File" },

      { "<leader>w", group = "Writing" },
      { "<leader>wz", desc = "Zen Mode" },
      { "<leader>wt", desc = "Twilight" },

      { "<leader>Y", desc = "Yazi File Manager" },

      { "g", group = "Go to" },
      { "gd", desc = "Go to Definition" },
      { "gD", desc = "Go to Declaration" },
      { "gr", desc = "Show References" },
      { "gi", desc = "Go to Implementation" },
      { "gt", desc = "Go to Type Definition" },

      { "]", group = "Next" },
      { "]d", desc = "Next Diagnostic" },
      { "]f", desc = "Next Function Start" },
      { "]F", desc = "Next Function End" },
      { "]c", desc = "Next Class Start" },
      { "]C", desc = "Next Class End" },
      { "]a", desc = "Next Parameter" },
      { "]i", desc = "Next Conditional" },
      { "]l", desc = "Next Loop" },
      { "]/", desc = "Next Comment" },

      { "[", group = "Previous" },
      { "[d", desc = "Previous Diagnostic" },
      { "[f", desc = "Previous Function Start" },
      { "[F", desc = "Previous Function End" },
      { "[c", desc = "Previous Class Start" },
      { "[C", desc = "Previous Class End" },
      { "[a", desc = "Previous Parameter" },
      { "[i", desc = "Previous Conditional" },
      { "[l", desc = "Previous Loop" },
      { "[/", desc = "Previous Comment" },

      { "K", desc = "Hover Documentation", mode = "n" },

      { "s", desc = "Flash Forward", mode = "n" },
      { "S", desc = "Flash Treesitter", mode = { "n", "x" } },
      { "r", desc = "Remote Flash", mode = "o" },
      { "R", desc = "Treesitter Search", mode = "o" },
    })
  end,
}
