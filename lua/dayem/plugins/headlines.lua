return {
  "lukas-reineke/headlines.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "org" },
  config = function()
    require("headlines").setup({
      org = {
        headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4" },
        fat_headlines = false,
        fat_headline_upper_string = "▄",
        fat_headline_lower_string = "▀",
      },
    })
  end,
}
