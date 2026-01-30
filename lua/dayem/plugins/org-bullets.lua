return {
  "akinsho/org-bullets.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-orgmode/orgmode",
  },
  ft = { "org" },
  config = function()
    require("org-bullets").setup({
      concealcursor = false,
      symbols = {
        headlines = { "◉", "○", "✸", "✿" },
        checkboxes = {
          half = { "", "@org.checkbox.halfchecked" },
          done = { "✓", "@org.keyword.done" },
          todo = { "˟", "@org.keyword.todo" },
        },
      },
    })
  end,
}
