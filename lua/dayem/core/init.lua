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
