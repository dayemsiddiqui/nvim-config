return {
	"nvim-telescope/telescope.nvim",
	branch = "master", -- using master to fix issues with deprecated to definition warnings 
    -- '0.1.x' for stable ver.
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"andrew-george/telescope-themes",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local root = require("dayem.utils.root")

		telescope.load_extension("fzf")
		telescope.load_extension("themes")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
			},
			extensions = {
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
						path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
					},
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end, { desc = "Find Connected Words under cursor" })

		vim.keymap.set("v", "<leader>pWs", function()
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local lines = vim.fn.getline(start_pos[2], end_pos[2])

			if #lines == 1 then
				lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
			else
				lines[1] = string.sub(lines[1], start_pos[3])
				lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
			end

			local search_term = table.concat(lines, "\n")
			builtin.grep_string({ search = search_term })
		end, { desc = "Find visual selection" })

		vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Project search with live grep" })

		vim.keymap.set("n", "<leader>ths", "<cmd>Telescope themes<CR>", { noremap = true, silent = true, desc = "Theme Switcher" })

		vim.keymap.set("n", "<leader><leader>", function()
			local root_dir = root.project_root()
			local ok = pcall(builtin.git_files, {
				cwd = root_dir,
				show_untracked = true,
			})
			if not ok then
				builtin.find_files({
					cwd = root_dir,
					hidden = true,
				})
			end
		end, { desc = "Smart find files (project)" })
    end,
}
