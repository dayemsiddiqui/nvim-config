local M = {}

local test_patterns = {
  php = { "Test%.php$", "tests/" },
  go = { "_test%.go$" },
  python = { "^test_.*%.py$", "_test%.py$", "tests/" },
  javascript = { "%.test%.js$", "%.spec%.js$" },
  typescript = { "%.test%.ts$", "%.spec%.ts$", "%.test%.tsx$", "%.spec%.tsx$" },
  rust = { "tests/.*%.rs$", "#%[test%]", "#%[cfg%(test%)%]" },
}

function M.is_test_file()
  local filepath = vim.fn.expand("%:p")
  local filetype = vim.bo.filetype

  local patterns = test_patterns[filetype]
  if not patterns then
    return false
  end

  for _, pattern in ipairs(patterns) do
    if filepath:match(pattern) then
      return true
    end
  end

  if filetype == "rust" then
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, 50, false), "\n")
    for _, pattern in ipairs({ "#%[test%]", "#%[cfg%(test%)%]" }) do
      if content:match(pattern) then
        return true
      end
    end
  end

  return false
end

function M.get_run_command()
  local filepath = vim.fn.expand("%:p")
  local filetype = vim.bo.filetype

  local commands = {
    php = "php " .. vim.fn.shellescape(filepath),
    go = function()
      local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, 20, false), "\n")
      if content:match("package main") then
        return "go run " .. vim.fn.shellescape(filepath)
      end
      return nil
    end,
    python = "python3 " .. vim.fn.shellescape(filepath),
    javascript = function()
      if vim.fn.executable("node") == 1 then
        return "node " .. vim.fn.shellescape(filepath)
      end
      return nil
    end,
    typescript = function()
      if vim.fn.executable("tsx") == 1 then
        return "tsx " .. vim.fn.shellescape(filepath)
      elseif vim.fn.executable("ts-node") == 1 then
        return "ts-node " .. vim.fn.shellescape(filepath)
      end
      return nil
    end,
    rust = "cargo run",
    lua = "lua " .. vim.fn.shellescape(filepath),
  }

  local cmd = commands[filetype]
  if type(cmd) == "function" then
    cmd = cmd()
  end

  return cmd
end

function M.get_test_command()
  local filepath = vim.fn.expand("%:p")
  local filetype = vim.bo.filetype

  local commands = {
    php = function()
      if vim.fn.filereadable("vendor/bin/pest") == 1 then
        return "vendor/bin/pest " .. vim.fn.shellescape(filepath)
      elseif vim.fn.filereadable("vendor/bin/phpunit") == 1 then
        return "vendor/bin/phpunit " .. vim.fn.shellescape(filepath)
      elseif vim.fn.filereadable("artisan") == 1 then
        return "php artisan test " .. vim.fn.shellescape(filepath)
      end
      return nil
    end,
    go = "go test -v -count=1 -timeout=60s " .. vim.fn.shellescape(vim.fn.expand("%:.:h")),
    python = "pytest -v " .. vim.fn.shellescape(filepath),
    javascript = "npm test -- " .. vim.fn.shellescape(filepath),
    typescript = "npm test -- " .. vim.fn.shellescape(filepath),
    rust = "cargo test",
  }

  local cmd = commands[filetype]
  if type(cmd) == "function" then
    cmd = cmd()
  end

  return cmd
end

function M.run_in_terminal(cmd, direction)
  if not cmd then
    vim.notify("No run command available for this file type", vim.log.levels.WARN)
    return
  end

  direction = direction or "horizontal"

  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = cmd,
    direction = direction,
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })

  term:toggle()
end

function M.run_program(direction)
  local cmd = M.get_run_command()
  if not cmd then
    vim.notify("Cannot run this file. Not a runnable file type or missing main function.", vim.log.levels.WARN)
    return
  end

  M.run_in_terminal(cmd, direction)
end

function M.run_test_fallback(direction)
  local cmd = M.get_test_command()
  if not cmd then
    vim.notify("No test command available for this file type", vim.log.levels.WARN)
    return
  end

  M.run_in_terminal(cmd, direction)
end

function M.smart_run(direction)
  if M.is_test_file() then
    local ok, neotest = pcall(require, "neotest")
    if ok then
      neotest.run.run(vim.fn.expand("%"))
    else
      M.run_test_fallback(direction)
    end
  else
    M.run_program(direction)
  end
end

function M.toggle_test_file()
  local filepath = vim.fn.expand("%:p")
  local filetype = vim.bo.filetype

  if filetype == "php" then
    if filepath:match("tests/") then
      local source = filepath:gsub("tests/", "app/"):gsub("Test%.php$", ".php")
      if vim.fn.filereadable(source) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(source))
      else
        vim.notify("Source file not found: " .. source, vim.log.levels.WARN)
      end
    else
      local test = filepath:gsub("app/", "tests/"):gsub("%.php$", "Test.php")
      if vim.fn.filereadable(test) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(test))
      else
        vim.notify("Test file not found: " .. test, vim.log.levels.WARN)
      end
    end
  elseif filetype == "go" then
    if filepath:match("_test%.go$") then
      local source = filepath:gsub("_test%.go$", ".go")
      if vim.fn.filereadable(source) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(source))
      else
        vim.notify("Source file not found: " .. source, vim.log.levels.WARN)
      end
    else
      local test = filepath:gsub("%.go$", "_test.go")
      if vim.fn.filereadable(test) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(test))
      else
        vim.notify("Test file not found: " .. test, vim.log.levels.WARN)
      end
    end
  elseif filetype == "python" then
    if filepath:match("test_.*%.py$") then
      local source = filepath:gsub("test_", ""):gsub("tests/", "")
      if vim.fn.filereadable(source) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(source))
      else
        vim.notify("Source file not found: " .. source, vim.log.levels.WARN)
      end
    else
      local dir = vim.fn.expand("%:p:h")
      local filename = vim.fn.expand("%:t")
      local test = dir .. "/test_" .. filename
      if vim.fn.filereadable(test) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(test))
      else
        vim.notify("Test file not found: " .. test, vim.log.levels.WARN)
      end
    end
  elseif filetype == "javascript" or filetype == "typescript" then
    if filepath:match("%.test%.") or filepath:match("%.spec%.") then
      local source = filepath:gsub("%.test%.", "."):gsub("%.spec%.", ".")
      if vim.fn.filereadable(source) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(source))
      else
        vim.notify("Source file not found: " .. source, vim.log.levels.WARN)
      end
    else
      local ext = vim.fn.expand("%:e")
      local test = filepath:gsub("%." .. ext .. "$", ".test." .. ext)
      if vim.fn.filereadable(test) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(test))
      else
        test = filepath:gsub("%." .. ext .. "$", ".spec." .. ext)
        if vim.fn.filereadable(test) == 1 then
          vim.cmd("edit " .. vim.fn.fnameescape(test))
        else
          vim.notify("Test file not found", vim.log.levels.WARN)
        end
      end
    end
  else
    vim.notify("Toggle test/source not supported for this file type", vim.log.levels.WARN)
  end
end

return M
