return {
	"nvim-orgmode/orgmode",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-telescope/telescope.nvim" },
		{ "joaomsa/telescope-orgmode.nvim" },
	},
	event = "VeryLazy",
	ft = { "org" },
	config = function()
		require("orgmode").setup({
			org_agenda_files = "~/orgfiles/**/*",
			org_default_notes_file = "~/orgfiles/refile.org",
			org_hide_emphasis_markers = true,
			org_startup_indented = true,
			org_agenda_templates = {
				t = { description = "Task", template = "* TODO %?\n  %u" },
				n = { description = "Note", template = "* %?\n  %u" },
			},
			mappings = {
				org = {
					org_toggle_checkbox = "<C-space>",
				org_schedule = ",s",
				org_deadline = ",d",
				},
			},
		})

		local ok, _ = pcall(require("telescope").load_extension, "orgmode")
		if not ok then
			vim.notify("Failed to load telescope-orgmode extension", vim.log.levels.WARN)
		end

		require("cmp").setup.filetype("org", {
			sources = {
				{ name = "orgmode" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
		})

		vim.keymap.set("n", "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", { desc = "Org Capture" })
		vim.keymap.set("n", "<leader>oh", "<cmd>Telescope orgmode search_headings<CR>", { desc = "Search Org Headings" })
		vim.keymap.set("n", "<leader>ol", "<cmd>Telescope orgmode insert_link<CR>", { desc = "Insert Org Link" })
	end,
}
