local M = {}

function M.project_root()
  -- 1. LSP root
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.config.root_dir then
      return client.config.root_dir
    end
  end

  -- 2. Git root
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root and git_root ~= "" then
    return git_root
  end

  -- 3. Fallback
  return vim.loop.cwd()
end

return M
