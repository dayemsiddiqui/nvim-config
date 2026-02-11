return {
  "folke/zen-mode.nvim",
  dependencies = { "folke/twilight.nvim" },
  keys = {
    { "<leader>wz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  opts = {
    window = {
      width = 80,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        colorcolumn = "",
        wrap = true,
        linebreak = true,
      },
    },
    plugins = {
      twilight = { enabled = true },
    },
  },
}
