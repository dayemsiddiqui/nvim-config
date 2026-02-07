return {
  "folke/twilight.nvim",
  keys = {
    { "<leader>wt", "<cmd>Twilight<cr>", desc = "Twilight" },
  },
  opts = {
    treesitter = true,
    context = 15,
    expand = {
      "function",
      "method",
      "table",
      "if_statement",
    },
  },
}
