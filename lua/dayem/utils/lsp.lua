local M = {}

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end

  return capabilities
end

function M.on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Go to definition" }))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { desc = "Show references" }))
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
  vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP Info" }))
  vim.keymap.set("n", "<leader>cR", "<cmd>LspRestart<cr>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
end

function M.setup_diagnostics()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
    },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

return M
