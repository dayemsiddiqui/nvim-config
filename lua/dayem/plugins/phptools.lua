return {
  "ccaglak/phptools.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
  },
  ft = { "php" },
  keys = {
    { "<leader>pm", "<cmd>PhpMethodCreate<cr>", desc = "PHP Create Method" },
    { "<leader>pc", "<cmd>PhpClassCreate<cr>", desc = "PHP Create Class" },
    { "<leader>pg", "<cmd>PhpGetSet<cr>", desc = "PHP Getters/Setters" },
    { "<leader>pn", "<cmd>PhpNamespace<cr>", desc = "PHP Add Namespace" },
    { "<leader>pt", "<cmd>PhpTest<cr>", desc = "PHP Run Test" },
  },
  config = function()
    require("phptools").setup({
      ui = true,
    })
  end,
}
