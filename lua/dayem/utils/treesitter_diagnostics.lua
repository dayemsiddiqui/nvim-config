local M = {}

function M.check_parser(lang)
  lang = lang or vim.bo.filetype
  local parser_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser/" .. lang .. ".so"

  if vim.fn.filereadable(parser_path) == 1 then
    print(string.format("✓ Parser for '%s' is installed at: %s", lang, parser_path))
    return true
  else
    print(string.format("✗ Parser for '%s' is NOT installed", lang))
    return false
  end
end

function M.check_highlighting()
  local ts_highlighter = require("vim.treesitter.highlighter")
  local bufnr = vim.api.nvim_get_current_buf()

  if ts_highlighter.active[bufnr] then
    print("✓ Treesitter highlighting is active for this buffer")
  else
    print("✗ Treesitter highlighting is NOT active for this buffer")
  end
end

function M.force_start()
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.bo[bufnr].filetype
  print(string.format("Attempting to start treesitter for '%s'...", lang))

  vim.bo[bufnr].syntax = ""
  vim.treesitter.stop(bufnr)

  vim.defer_fn(function()
    local ok, err = pcall(vim.treesitter.start, bufnr, lang)
    if ok then
      print(string.format("✓ Successfully started treesitter for '%s'", lang))
    else
      print(string.format("✗ Failed to start treesitter: %s", tostring(err)))
    end
  end, 50)
end

function M.force_reload()
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.bo[bufnr].filetype

  print("Force reloading treesitter...")
  print("Disabling LSP...")

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    print(string.format("  Detaching %s", client.name))
    vim.lsp.buf_detach_client(bufnr, client.id)
  end

  vim.bo[bufnr].syntax = ""
  vim.treesitter.stop(bufnr)

  vim.defer_fn(function()
    vim.treesitter.start(bufnr, lang)
    print("✓ Treesitter reloaded (LSP detached)")
    print("To re-enable LSP, run: :LspRestart")
  end, 100)
end

function M.full_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.bo[bufnr].filetype

  print("=== Treesitter Diagnostics ===")
  print(string.format("Filetype: %s", lang))

  local parser_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser/" .. lang .. ".so"
  print(string.format("Parser installed: %s", vim.fn.filereadable(parser_path) == 1 and "✓" or "✗"))

  local has_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  print(string.format("Parser loadable: %s", has_parser and "✓" or "✗"))

  local has_queries = pcall(vim.treesitter.query.get, lang, "highlights")
  print(string.format("Highlight queries available: %s", has_queries and "✓" or "✗"))

  local ts_highlighter = require("vim.treesitter.highlighter")
  local is_active = ts_highlighter.active[bufnr] ~= nil
  print(string.format("Treesitter highlighting active: %s", is_active and "✓" or "✗"))

  local sample_groups = { "@keyword", "@function", "@function.call", "@type", "@string", "@variable", "@number", "@operator", "@property" }
  print("\nHighlight groups:")
  for _, group in ipairs(sample_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if next(hl) ~= nil then
      local fg = hl.fg and string.format("#%06x", hl.fg) or "none"
      local bg = hl.bg and string.format("#%06x", hl.bg) or "none"
      print(string.format("  %s: fg=%s bg=%s", group, fg, bg))
    else
      local linked = vim.api.nvim_get_hl(0, { name = group })
      if next(linked) ~= nil then
        print(string.format("  %s: linked to another group", group))
      else
        print(string.format("  %s: NOT DEFINED", group))
      end
    end
  end

  print("\nTerminal settings:")
  print(string.format("  termguicolors: %s", vim.o.termguicolors and "enabled" or "DISABLED"))
  print(string.format("  colorscheme: %s", vim.g.colors_name or "none"))

  print("\nTry running :Inspect with cursor on a keyword to see applied highlights")
end

function M.apply_highlights()
  local highlights = {
    ["@keyword"] = { fg = "#eb6f92" },
    ["@keyword.function"] = { fg = "#eb6f92" },
    ["@keyword.return"] = { fg = "#eb6f92" },
    ["@keyword.operator"] = { fg = "#eb6f92" },
    ["@function"] = { fg = "#c4a7e7" },
    ["@function.builtin"] = { fg = "#ea9a97" },
    ["@function.method"] = { fg = "#c4a7e7" },
    ["@function.call"] = { fg = "#c4a7e7" },
    ["@type"] = { fg = "#9ccfd8" },
    ["@type.builtin"] = { fg = "#9ccfd8" },
    ["@variable"] = { fg = "#e0def4" },
    ["@variable.builtin"] = { fg = "#ea9a97" },
    ["@variable.parameter"] = { fg = "#f6c177" },
    ["@constant"] = { fg = "#f6c177" },
    ["@constant.builtin"] = { fg = "#ea9a97" },
    ["@string"] = { fg = "#f6c177" },
    ["@string.escape"] = { fg = "#eb6f92" },
    ["@number"] = { fg = "#ea9a97" },
    ["@boolean"] = { fg = "#ea9a97" },
    ["@operator"] = { fg = "#908caa" },
    ["@punctuation.bracket"] = { fg = "#908caa" },
    ["@punctuation.delimiter"] = { fg = "#908caa" },
    ["@property"] = { fg = "#9ccfd8" },
    ["@comment"] = { fg = "#6e6a86", italic = true },
  }
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
  print("✓ Highlight groups applied")
end

return M
