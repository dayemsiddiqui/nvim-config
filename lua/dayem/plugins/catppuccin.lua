return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = true,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        semantic_tokens = true,
        telescope = {
          enabled = true,
        },
        cmp = true,
        gitsigns = true,
        neotree = true,
        mini = true,
      },
      custom_highlights = function(colors)
        return {
          ["@function"] = { fg = colors.blue, style = { "bold" } },
          ["@function.call"] = { fg = colors.blue },
          ["@variable.parameter"] = { fg = colors.peach, style = { "italic" } },
          ["@type"] = { fg = colors.yellow, style = { "italic" } },
          ["@property"] = { fg = colors.teal },
          ["@constant"] = { fg = colors.peach, style = { "bold" } },

          ["@lsp.type.namespace"] = { fg = colors.sky },
          ["@lsp.type.type"] = { fg = colors.yellow, style = { "italic" } },
          ["@lsp.type.interface"] = { fg = colors.yellow, style = { "italic", "bold" } },
          ["@lsp.type.struct"] = { fg = colors.yellow, style = { "italic" } },
          ["@lsp.type.typeParameter"] = { fg = colors.yellow, style = { "italic" } },
          ["@lsp.type.parameter"] = { fg = colors.peach, style = { "italic" } },
          ["@lsp.type.variable"] = { fg = colors.text },
          ["@lsp.type.property"] = { fg = colors.teal },
          ["@lsp.type.enumMember"] = { fg = colors.peach, style = { "bold" } },
          ["@lsp.type.function"] = { fg = colors.blue, style = { "bold" } },
          ["@lsp.type.method"] = { fg = colors.blue },
          ["@lsp.type.macro"] = { fg = colors.mauve },
          ["@lsp.type.decorator"] = { fg = colors.peach },

          ["@lsp.mod.readonly"] = { fg = colors.peach },
          ["@lsp.mod.deprecated"] = { fg = colors.overlay2, style = { "strikethrough" } },
          ["@lsp.mod.defaultLibrary"] = { fg = colors.sky },
          ["@lsp.mod.static"] = { style = { "bold" } },

          ["LspInlayHint"] = { fg = colors.overlay0, bg = colors.surface0 },
        }
      end,
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
