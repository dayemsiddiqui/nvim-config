return {
  "adalessa/laravel.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
  },
  cmd = { "Laravel" },
  keys = {
    { "<leader>la", ":Laravel artisan<cr>", desc = "Laravel Artisan" },
    { "<leader>lr", ":Laravel routes<cr>", desc = "Laravel Routes" },
    { "<leader>lm", ":Laravel related<cr>", desc = "Laravel Related" },
  },
  event = { "VeryLazy" },
  config = function()
    require("laravel").setup({
      features = {
        null_ls = {
          enable = false,
        },
      },
      lsp_server = "intelephense",
    })
  end,
}
