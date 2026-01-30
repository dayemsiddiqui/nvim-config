vim.g.mapleader = " "
vim.g.maplocalleader = " "


require("dayem.core.options")
require("dayem.core.keymaps")

vim.api.nvim_create_user_command("TSCheckParser", function()
  require("dayem.utils.treesitter_diagnostics").check_parser()
end, {})

vim.api.nvim_create_user_command("TSCheckHighlight", function()
  require("dayem.utils.treesitter_diagnostics").check_highlighting()
end, {})

vim.api.nvim_create_user_command("TSForceStart", function()
  require("dayem.utils.treesitter_diagnostics").force_start()
end, {})

vim.api.nvim_create_user_command("TSDiag", function()
  require("dayem.utils.treesitter_diagnostics").full_diagnostics()
end, {})

vim.api.nvim_create_user_command("TSReload", function()
  require("dayem.utils.treesitter_diagnostics").force_reload()
end, {})

vim.api.nvim_create_user_command("TSApplyColors", function()
  require("dayem.utils.treesitter_diagnostics").apply_highlights()
end, {})

vim.api.nvim_create_user_command("FixOrgColors", function()
  local colors = require("catppuccin.palettes").get_palette()
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.text })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.text, bg = colors.mantle })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue, bg = colors.mantle })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.text, bg = colors.mantle })
  vim.api.nvim_set_hl(0, "SnacksInput", { fg = colors.text, bg = colors.mantle })
  vim.api.nvim_set_hl(0, "SnacksInputBorder", { fg = colors.blue, bg = colors.mantle })
  vim.api.nvim_set_hl(0, "SnacksInputTitle", { fg = colors.blue, bg = colors.mantle })
  vim.cmd("highlight! link OrgAgendaScheduled Normal")
  vim.cmd("highlight! link OrgAgendaDeadline Normal")
  print("Orgmode colors fixed!")
end, {})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local colors = require("catppuccin.palettes").get_palette()
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.text, bg = colors.mantle })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue, bg = colors.mantle })
    vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.text, bg = colors.mantle })
    vim.api.nvim_set_hl(0, "SnacksInput", { fg = colors.text, bg = colors.mantle })
    vim.api.nvim_set_hl(0, "SnacksInputBorder", { fg = colors.blue, bg = colors.mantle })
    vim.api.nvim_set_hl(0, "SnacksInputTitle", { fg = colors.blue, bg = colors.mantle })
  end,
})
