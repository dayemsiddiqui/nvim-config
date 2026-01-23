return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>y",
      function()
        require("yazi").yazi()
      end,
      desc = "Yazi (file operations)",
    },
  },
  opts = {
    open_for_directories = false, -- don't hijack netrw
  },
}

