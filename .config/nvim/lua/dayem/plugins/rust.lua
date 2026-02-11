return {
  event = "VeryLazy",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        require("which-key").add({
          { "<leader>r", ":!bacon R<CR>", desc = "Run bacon R", buffer = true }
        })
      end,
    })
  end,
}
