return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 1000,
  lazy = false,
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    local colors = {
      color0 = "#1e1e2e",
      color1 = "#45475a",
      color2 = "#cdd6f4",
      color3 = "#f38ba8",
      color4 = "#a6e3a1",
      color5 = "#89b4fa",
      color6 = "#f9e2af",
      color7 = "#fab387",
      color8 = "#cba6f7",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.color5, fg = colors.color0, gui = "bold" },
        b = { bg = colors.color1, fg = colors.color2 },
        c = { bg = colors.color0, fg = colors.color2 },
      },
      insert = {
        a = { bg = colors.color4, fg = colors.color0, gui = "bold" },
        b = { bg = colors.color1, fg = colors.color2 },
        c = { bg = colors.color0, fg = colors.color2 },
      },
      visual = {
        a = { bg = colors.color8, fg = colors.color0, gui = "bold" },
        b = { bg = colors.color1, fg = colors.color2 },
        c = { bg = colors.color0, fg = colors.color2 },
      },
      replace = {
        a = { bg = colors.color3, fg = colors.color0, gui = "bold" },
        b = { bg = colors.color1, fg = colors.color2 },
        c = { bg = colors.color0, fg = colors.color2 },
      },
      command = {
        a = { bg = colors.color6, fg = colors.color0, gui = "bold" },
        b = { bg = colors.color1, fg = colors.color2 },
        c = { bg = colors.color0, fg = colors.color2 },
      },
      inactive = {
        a = { bg = colors.color1, fg = colors.color2 },
        b = { bg = colors.color0, fg = colors.color1 },
        c = { bg = colors.color0, fg = colors.color1 },
      },
    }

    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
    }

    local filename = {
      "filename",
      file_status = true,
      path = 1,
    }

    local branch = {
      "branch",
      icon = "",
    }

    local diff = {
      "diff",
      colored = true,
      symbols = { added = " ", modified = " ", removed = " " },
    }

    lualine.setup({
      options = {
        icons_enabled = true,
        theme = my_lualine_theme,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "alpha", "dashboard" },
          winbar = {},
        },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch, diff },
        lualine_c = { filename },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = colors.color7 },
          },
          "filetype",
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "nvim-tree", "lazy" },
    })
  end,
}
