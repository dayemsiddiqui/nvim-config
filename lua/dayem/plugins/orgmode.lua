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
		vim.keymap.set("n", "<leader>ona", "<cmd>lua require('orgmode').action('org_mappings.add_note')<CR>", { desc = "Add Note to TODO" })

		vim.keymap.set("n", "<leader>onb", function()
			local line = vim.api.nvim_get_current_line()
			if line:match("^%*+%s+TODO") or line:match("^%*+%s+DONE") then
				local indent = line:match("^(%*+)")
				vim.cmd("normal! o")
				vim.api.nvim_set_current_line(indent .. " NOTE ")
				vim.cmd("startinsert!")
			else
				vim.notify("Cursor must be on a TODO/DONE heading", vim.log.levels.WARN)
			end
		end, { desc = "Add Note in Buffer (inline)" })

		vim.keymap.set("n", "<leader>ons", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local line_num = vim.api.nvim_win_get_cursor(0)[1]
			local line = vim.api.nvim_get_current_line()

			if line:match("^%*+%s+TODO") or line:match("^%*+%s+DONE") then
				vim.cmd("split")
				vim.cmd("enew")

				local note_buf = vim.api.nvim_get_current_buf()
				vim.api.nvim_buf_set_option(note_buf, 'buftype', 'acwrite')
				vim.api.nvim_buf_set_option(note_buf, 'filetype', 'org')
				vim.api.nvim_buf_set_name(note_buf, "Note for: " .. line:gsub("^%*+%s+", ""))

				vim.api.nvim_buf_set_lines(note_buf, 0, -1, false, {
					"",
					""
				})

				vim.cmd("startinsert")

				vim.api.nvim_create_autocmd("BufWriteCmd", {
					buffer = note_buf,
					callback = function()
						local note_lines = vim.api.nvim_buf_get_lines(note_buf, 0, -1, false)

						local filtered_lines = {}
						for _, l in ipairs(note_lines) do
							if l:match("%S") then
								table.insert(filtered_lines, "  " .. l)
							end
						end

						if #filtered_lines > 0 then
							vim.api.nvim_buf_set_lines(bufnr, line_num, line_num, false, filtered_lines)
							vim.notify("Note added to TODO item", vim.log.levels.INFO)
							vim.cmd("bdelete!")
						else
							vim.notify("Note is empty, not adding", vim.log.levels.WARN)
						end
					end,
				})
			else
				vim.notify("Cursor must be on a TODO/DONE heading", vim.log.levels.WARN)
			end
		end, { desc = "Add Note in Split Buffer (save with :w)" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "org",
			callback = function()
				vim.cmd([[
					highlight! link OrgAgendaScheduled Normal
					highlight! link OrgAgendaDeadline Normal
					highlight! link OrgTSHeadlineLevel1 Normal
					highlight! link OrgTSHeadlineLevel2 Normal
					highlight! link OrgTSHeadlineLevel3 Normal
					highlight! link @org.headline.level1.org Normal
					highlight! link @org.headline.level2.org Normal
					highlight! link @org.headline.level3.org Normal
				]])
			end,
		})
	end,
}
