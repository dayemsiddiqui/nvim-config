return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        priority = 1000,
        config = function()
            require("nvim-treesitter.config").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            require("nvim-treesitter").install({
                "json",
                "javascript",
                "typescript",
                "tsx",
                "go",
                "yaml",
                "html",
                "css",
                "python",
                "http",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "java",
                "rust",
                "ron",
                "php",
                "blade",
                "vue",
                "astro",
                "templ",
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false,
        config = function()
            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")
            local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@function.outer"] = "V",
                        ["@class.outer"] = "V",
                        ["@conditional.outer"] = "V",
                        ["@loop.outer"] = "V",
                        ["@block.outer"] = "V",
                    },
                    include_surrounding_whitespace = false,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select_maps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ai"] = "@conditional.outer",
                ["ii"] = "@conditional.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["am"] = "@call.outer",
                ["im"] = "@call.inner",
                ["a/"] = "@comment.outer",
                ["i/"] = "@comment.inner",
                ["ar"] = "@return.outer",
                ["ir"] = "@return.inner",
            }
            for key, query in pairs(select_maps) do
                vim.keymap.set({ "x", "o" }, key, function()
                    select.select_textobject(query, "textobjects")
                end)
            end

            local next_start_maps = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]a"] = "@parameter.inner",
                ["]i"] = "@conditional.outer",
                ["]l"] = "@loop.outer",
                ["]/"] = "@comment.outer",
            }
            for key, query in pairs(next_start_maps) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_next_start(query, "textobjects")
                end)
            end

            local next_end_maps = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
            }
            for key, query in pairs(next_end_maps) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_next_end(query, "textobjects")
                end)
            end

            local prev_start_maps = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[a"] = "@parameter.inner",
                ["[i"] = "@conditional.outer",
                ["[l"] = "@loop.outer",
                ["[/"] = "@comment.outer",
            }
            for key, query in pairs(prev_start_maps) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_previous_start(query, "textobjects")
                end)
            end

            local prev_end_maps = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
            }
            for key, query in pairs(prev_end_maps) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_previous_end(query, "textobjects")
                end)
            end

            vim.keymap.set("n", "<leader>sa", function() swap.swap_next("@parameter.inner") end)
            vim.keymap.set("n", "<leader>sA", function() swap.swap_previous("@parameter.inner") end)
            vim.keymap.set("n", "<leader>sf", function() swap.swap_next("@function.outer") end)
            vim.keymap.set("n", "<leader>sF", function() swap.swap_previous("@function.outer") end)

            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        enabled = true,
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "php", "blade", "vue", "astro", "markdown", "templ", "gohtml", "gohtmltmpl" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = true,
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true,
                    },
                    ["typescriptreact"] = {
                        enable_close = true,
                    },
                },
            })
        end,
    },
}
