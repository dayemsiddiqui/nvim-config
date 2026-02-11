
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermNew", "TermSelect" },
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
      start_in_insert = true,
      persist_size = true,
      close_on_exit = false,
      open_mapping = nil,
    })

    vim.keymap.set("n", "<C-\\>", function()
      local Terminal = require("toggleterm.terminal").Terminal
      local term = Terminal:new({ direction = "horizontal", id = 1 })
      term:toggle()
    end, { desc = "Toggle horizontal terminal" })

    vim.keymap.set("n", "<C-t>", function()
      local Terminal = require("toggleterm.terminal").Terminal
      local term = Terminal:new({ direction = "tab" })
      term:toggle()
    end, { desc = "New toggleterm tab" })

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function()
        local opts = { buffer = 0, silent = true }
        vim.keymap.set("t", "<C-\\>", function()
          require("toggleterm.terminal").Terminal:new({ direction = "horizontal", id = 1 }):toggle()
        end, opts)
        vim.keymap.set("t", "<C-t>", function()
          require("toggleterm.terminal").Terminal:new({ direction = "tab" }):toggle()
        end, opts)
      end,
    })
  end,
}
