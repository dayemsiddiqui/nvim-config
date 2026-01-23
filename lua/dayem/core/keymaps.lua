local opts = { noremap = true, silent = true }


vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in the buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)


-- Paste without replacing the clipboard conten
vim.keymap.set("x", "<leader>p", [["_dP"]])

vim.keymap.set("v", "p", '"_dp', opts)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
vim.keymap.set("n", "x", '"_x', opts)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word cursor is on globally" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- tab stuff
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>") -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>bdelete<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>BufferLineCycleNext<CR>") -- go to next
vim.keymap.set("n", "<leader>tp", "<cmd>BufferLineCyclePrev<CR>") -- go to pre
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>") -- open current file in new tab

-- split
vim.keymap.set("n", "<leader>sv", function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.cmd("vsplit")
  vim.api.nvim_set_current_buf(current_buf)
  vim.cmd("wincmd p")

  pcall(vim.cmd, "BufferLineCyclePrev")
  if vim.api.nvim_get_current_buf() == current_buf then
    pcall(vim.cmd, "BufferLineCycleNext")
    if vim.api.nvim_get_current_buf() == current_buf then
      vim.cmd("enew")
    end
  end
end, { desc = "Move buffer to vertical split" })

vim.keymap.set("n", "<leader>sh", function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.cmd("split")
  vim.api.nvim_set_current_buf(current_buf)
  vim.cmd("wincmd p")

  pcall(vim.cmd, "BufferLineCyclePrev")
  if vim.api.nvim_get_current_buf() == current_buf then
    pcall(vim.cmd, "BufferLineCycleNext")
    if vim.api.nvim_get_current_buf() == current_buf then
      vim.cmd("enew")
    end
  end
end, { desc = "Move buffer to horizontal split" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make split equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close the current split" })
vim.keymap.set('n', '<leader>sn', '<C-w>wgg0', { desc = 'Next split' })                                                                                                               
vim.keymap.set('n', '<leader>sp', '<C-w>pgg0', { desc = 'Previous split' }) 

-- Copy the filepath to clipboard
vim.keymap.set("n", "<leader>fp", function()
    local filepath = vim.fn.expand("%:~")
    vim.fn.setreg("+", filepath)
    print("File path copied to clipboard: " .. filepath)
end, { desc = "Copy filepath to clipboard" })


vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Explorer (Neo-tree)" })

vim.keymap.set("n", "<leader>Y", function()
  require("yazi").yazi({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Yazi (cwd = current file)" })

vim.api.nvim_create_autocmd("User", {
  pattern = "YaziOpen",
  callback = function()
    vim.cmd("Neotree close")
  end,
})

vim.keymap.set("n", "<leader>gha", function()
  local github = require("dayem.utils.github")
  local accounts = github.list_accounts()

  if #accounts == 0 then
    vim.notify("No GitHub accounts authenticated. Run 'gh auth login'", vim.log.levels.WARN)
    return
  end

  vim.ui.select(accounts, {
    prompt = "Select GitHub Account:",
    format_item = function(item)
      return item.username
    end,
  }, function(choice)
    if choice then
      github.switch_account(choice.username)
    end
  end)
end, { desc = "Switch GitHub Account" })

vim.keymap.set("n", "<leader>ghs", function()
  local github = require("dayem.utils.github")
  local account = github.get_current_account()

  if account then
    vim.notify(" GitHub: " .. account.username, vim.log.levels.INFO)
  else
    vim.notify("No GitHub account authenticated", vim.log.levels.WARN)
  end
end, { desc = "Show GitHub Account Status" })

vim.keymap.set("n", "<leader>ght", function()
  vim.g.github_auto_switch = not vim.g.github_auto_switch
  local status = vim.g.github_auto_switch and "enabled" or "disabled"
  vim.notify("GitHub auto-switch " .. status, vim.log.levels.INFO)
end, { desc = "Toggle GitHub Auto-Switch" })

vim.keymap.set("n", "<leader>ghr", function()
  local github = require("dayem.utils.github")
  local accounts = github.list_accounts()

  if #accounts == 0 then
    vim.notify("No GitHub accounts authenticated. Run 'gh auth login'", vim.log.levels.WARN)
    return
  end

  vim.ui.select(accounts, {
    prompt = "Register current project with account:",
    format_item = function(item)
      return item.username
    end,
  }, function(choice)
    if choice then
      github.register_project(choice.username)
    end
  end)
end, { desc = "Register Project with GitHub Account" })

vim.keymap.set("n", "<leader>ghu", function()
  require("dayem.utils.github").unregister_project()
end, { desc = "Unregister Project GitHub Account" })

