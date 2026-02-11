return {
    "mistweaverco/kulala.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "http", "rest" },
    keys = {
        { "<leader>Rs", desc = "Send request" },
        { "<leader>Ra", desc = "Send all requests" },
        { "<leader>Rb", desc = "Open scratchpad" },
        { "<leader>Re", desc = "Select environment" },
    },
    opts = {
        global_keymaps = true,
        global_keymaps_prefix = "<leader>R",
        kulala_keymaps_prefix = "",
        lsp = {
            enable = true,
            formatter = {
                sort = {
                    metadata = true,
                    variables = true,
                },
            },
        },
    },
    init = function()
        vim.filetype.add({
            extension = {
                http = "http",
            },
        })
    end,
}
