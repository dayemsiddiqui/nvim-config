return {
  "gbprod/phpactor.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = { "php" },
  keys = {
    { "<leader>paa", "<cmd>PhpActor context_menu<cr>", desc = "PhpActor Menu" },
    { "<leader>pan", "<cmd>PhpActor new_class<cr>", desc = "PhpActor New Class" },
    { "<leader>pae", "<cmd>PhpActor extract_method<cr>", mode = "v", desc = "Extract Method" },
    { "<leader>pai", "<cmd>PhpActor import_class<cr>", desc = "Import Class" },
    { "<leader>par", "<cmd>PhpActor rename<cr>", desc = "PhpActor Rename" },
  },
  build = function()
    require("phpactor.handler.update")()
  end,
  config = function()
    require("phpactor").setup({
      install = {
        path = vim.fn.stdpath("data") .. "/phpactor",
        branch = "master",
        bin = vim.fn.stdpath("data") .. "/phpactor/bin/phpactor",
        php_bin = "php",
        composer_bin = "composer",
        git_bin = "git",
        check_on_startup = "none",
      },
      lspconfig = {
        enabled = false,
      },
    })
  end,
}
