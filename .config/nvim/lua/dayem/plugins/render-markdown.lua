return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("render-markdown").setup({
      enabled = true,
      max_file_size = 10.0,
      debounce = 100,
      render_modes = { "n", "c", "t" },
      file_types = { "markdown" },

      heading = {
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },

      code = {
        enabled = true,
        sign = true,
        style = "full",
        width = "block",
        border = "thin",
      },

      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },

      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
        },
        checked = {
          icon = "󰱒 ",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 " },
        },
      },

      quote = {
        enabled = true,
        icon = "▎",
      },

      pipe_table = {
        enabled = true,
        style = "full",
        cell = "padded",
      },

      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
      },
    })
  end,
}
