local M = {}

function M.setup()
    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "go",
        callback = function(ev)
            vim.defer_fn(function()
                local bufnr = ev.buf
                print("=== Go FileType Debug ===")
                print("Buffer: " .. bufnr)
                print("Syntax: " .. vim.bo[bufnr].syntax)

                local ts_active = require("vim.treesitter.highlighter").active[bufnr]
                print("TS Active: " .. (ts_active and "yes" or "NO"))

                local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
                print("LSP clients: " .. #lsp_clients)
                for _, client in ipairs(lsp_clients) do
                    print("  - " .. client.name)
                end
            end, 500)
        end,
    })
end

return M
