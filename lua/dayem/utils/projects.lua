local M = {}

M.projects = {
  { name = "Neovim Config", path = "~/.config/nvim" },
}

M.data_file = vim.fn.stdpath("data") .. "/projects.json"

function M.load_dynamic_projects()
  if vim.fn.filereadable(M.data_file) == 0 then
    return {}
  end

  local ok, content = pcall(vim.fn.readfile, M.data_file)
  if not ok then
    vim.notify("Failed to read projects file", vim.log.levels.WARN)
    return {}
  end

  local json_str = table.concat(content, "\n")
  if json_str == "" then
    return {}
  end

  local decode_ok, projects = pcall(vim.json.decode, json_str)
  if not decode_ok then
    vim.notify("Failed to parse projects file", vim.log.levels.WARN)
    return {}
  end

  return projects or {}
end

function M.save_dynamic_projects(projects)
  local ok, json_str = pcall(vim.json.encode, projects)
  if not ok then
    vim.notify("Failed to encode projects to JSON", vim.log.levels.ERROR)
    return false
  end

  local write_ok = pcall(vim.fn.writefile, { json_str }, M.data_file)
  if not write_ok then
    vim.notify("Failed to write projects file", vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.get_all_projects()
  local all_projects = vim.deepcopy(M.projects)
  local dynamic = M.load_dynamic_projects()

  for _, project in ipairs(dynamic) do
    table.insert(all_projects, project)
  end

  return all_projects
end

function M.detect_project_name()
  local cwd = vim.loop.cwd()

  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local base_path
  if git_root and git_root ~= "" and not git_root:match("^fatal:") then
    base_path = git_root
  else
    base_path = cwd
  end

  local name = vim.fn.fnamemodify(base_path, ":t")

  name = name:gsub("[-_]", " ")
  name = name:gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)

  return name
end

function M.add_current_project(name)
  local cwd = vim.loop.cwd()
  local dynamic_projects = M.load_dynamic_projects()

  for _, project in ipairs(dynamic_projects) do
    if project.path == cwd then
      vim.notify("Project already exists: " .. project.name, vim.log.levels.WARN)
      return
    end
  end

  table.insert(dynamic_projects, {
    name = name,
    path = cwd,
  })

  if M.save_dynamic_projects(dynamic_projects) then
    vim.notify("Project '" .. name .. "' added successfully", vim.log.levels.INFO)
  end
end

function M.delete_project(name)
  local dynamic_projects = M.load_dynamic_projects()
  local found_index = nil

  for i, project in ipairs(dynamic_projects) do
    if project.name == name then
      found_index = i
      break
    end
  end

  if not found_index then
    vim.notify("Project not found: " .. name, vim.log.levels.ERROR)
    return false
  end

  table.remove(dynamic_projects, found_index)

  if M.save_dynamic_projects(dynamic_projects) then
    vim.notify("Project '" .. name .. "' deleted successfully", vim.log.levels.INFO)
    return true
  end

  return false
end

function M.get_dynamic_project_items()
  local items = {}
  for _, project in ipairs(M.load_dynamic_projects()) do
    table.insert(items, {
      text = project.name,
      path = vim.fn.expand(project.path),
      name = project.name,
    })
  end
  return items
end

function M.get_projects()
  local items = {}
  for _, project in ipairs(M.get_all_projects()) do
    table.insert(items, {
      text = project.name,
      path = vim.fn.expand(project.path),
      name = project.name,
    })
  end
  return items
end

function M.switch_to_project(path)
  local expanded_path = vim.fn.expand(path)

  if vim.fn.isdirectory(expanded_path) == 0 then
    vim.notify("Project directory does not exist: " .. expanded_path, vim.log.levels.ERROR)
    return
  end

  local modified_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname ~= "" then
        table.insert(modified_buffers, bufname)
      end
    end
  end

  if #modified_buffers > 0 then
    local response = vim.fn.confirm(
      "You have unsaved changes. Continue switching projects?",
      "&Yes\n&No",
      2
    )
    if response ~= 1 then
      return
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      if buftype == "" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end

  vim.cmd("cd " .. vim.fn.fnameescape(expanded_path))

  local restore_success = pcall(function()
    vim.cmd("SessionRestore")
  end)

  if not restore_success then
    vim.schedule(function()
      vim.cmd("Neotree show")
    end)
  end

  vim.notify("Switched to project: " .. expanded_path, vim.log.levels.INFO)
end

return M
