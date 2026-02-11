return {
  name = "github-cli",
  dir = vim.fn.stdpath("config") .. "/lua/dayem/utils",
  dependencies = { "nvim-lualine/lualine.nvim" },
  lazy = false,
  priority = 999,

  config = function()
    vim.g.github_auto_switch = true

    local group = vim.api.nvim_create_augroup("GitHubCLI", { clear = true })

    vim.api.nvim_create_autocmd("DirChanged", {
      group = group,
      callback = function()
        vim.schedule(function()
          require("dayem.utils.github").auto_switch()
        end)
      end,
    })
  end,
}
