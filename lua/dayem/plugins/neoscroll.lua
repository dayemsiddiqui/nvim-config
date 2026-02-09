return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    require('neoscroll').setup({
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing = "linear",
      performance_mode = false,
    })

    local neoscroll = require('neoscroll')
    local keymap = {
      ["{"] = function() neoscroll.scroll(-vim.wo.scroll, {move_cursor=true, duration=150}) end,
      ["}"] = function() neoscroll.scroll(vim.wo.scroll, {move_cursor=true, duration=150}) end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
