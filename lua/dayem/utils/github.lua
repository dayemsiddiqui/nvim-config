local M = {}

local cache = { data = nil, timestamp = 0 }
local CACHE_DURATION = 300

function M.get_current_account()
  local now = vim.loop.hrtime() / 1e9
  if cache.data and (now - cache.timestamp) < CACHE_DURATION then
    return cache.data
  end

  local cached_data = cache.data

  vim.system(
    { "gh", "auth", "status" },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code == 0 then
        for _, line in ipairs(vim.split(result.stdout or "", "\n")) do
          local username = line:match("Logged in to github%.com account (%S+)")
          if username then
            cache.data = { username = username }
            cache.timestamp = vim.loop.hrtime() / 1e9
            require("lualine").refresh()
            break
          end
        end
      end
    end)
  )

  return cached_data
end

function M.list_accounts()
  local output = vim.fn.systemlist("gh auth status 2>&1")
  local accounts = {}

  for _, line in ipairs(output) do
    local username = line:match("Logged in to github%.com account (%S+)")
    if username then
      table.insert(accounts, { username = username })
    end
  end

  return accounts
end

function M.switch_account(username)
  local result = vim.fn.system("gh auth switch --user " .. username .. " 2>&1")

  if vim.v.shell_error == 0 then
    cache.data = nil
    vim.notify("Switched to GitHub account: " .. username, vim.log.levels.INFO)
    require("lualine").refresh()
    return true
  else
    vim.notify("Failed to switch account: " .. result, vim.log.levels.ERROR)
    return false
  end
end

local MAPPINGS_FILE = vim.fn.stdpath("config") .. "/github-projects.json"

function M.load_mappings()
  if vim.fn.filereadable(MAPPINGS_FILE) == 0 then
    return {}
  end

  local content = vim.fn.readfile(MAPPINGS_FILE)
  local ok, mappings = pcall(vim.fn.json_decode, table.concat(content, "\n"))

  return ok and mappings or {}
end

function M.save_mappings(mappings)
  local json = vim.fn.json_encode(mappings)
  vim.fn.writefile({ json }, MAPPINGS_FILE)
end

function M.get_project_account()
  local root = require("dayem.utils.root").project_root()
  local mappings = M.load_mappings()
  return mappings[root]
end

function M.register_project(username)
  local root = require("dayem.utils.root").project_root()
  local mappings = M.load_mappings()

  mappings[root] = username
  M.save_mappings(mappings)

  vim.notify("Registered " .. root .. " → " .. username, vim.log.levels.INFO)
end

function M.unregister_project()
  local root = require("dayem.utils.root").project_root()
  local mappings = M.load_mappings()

  if mappings[root] then
    mappings[root] = nil
    M.save_mappings(mappings)
    vim.notify("Unregistered " .. root, vim.log.levels.INFO)
  else
    vim.notify("No mapping found for " .. root, vim.log.levels.WARN)
  end
end

local last_project_root = nil

function M.auto_switch()
  if not vim.g.github_auto_switch then
    return
  end

  local root = require("dayem.utils.root").project_root()
  if root == last_project_root then
    return
  end

  last_project_root = root
  local project_account = M.get_project_account()

  if project_account then
    local current = M.get_current_account()
    if not current or current.username ~= project_account then
      M.switch_account(project_account)
    end
  end
end

return M
