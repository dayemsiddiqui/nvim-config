return {
  "ricardoramirezr/blade-nav.nvim",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  ft = { "blade", "php" },
  config = function()
    require("blade-nav").setup({
      close_tag_on_complete = true,
      include_routes = true,
    })
  end,
}
