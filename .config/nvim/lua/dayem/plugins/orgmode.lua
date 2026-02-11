return {
	"nvim-orgmode/orgmode",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-telescope/telescope.nvim" },
	},
	event = "VeryLazy",
	ft = { "org" },
	config = function()
		local Menu = require("org-modern.menu")

		require("orgmode").setup({
			org_agenda_files = "~/orgfiles/**/*",
			org_default_notes_file = "~/orgfiles/refile.org",
			org_hide_emphasis_markers = true,
			org_startup_indented = true,
			win_split_mode = 'float',
			win_border = 'rounded',
			org_capture_templates = {
				t = { description = "Task", template = "* TODO %?\n  %u" },
				n = { description = "Note", template = "* %?\n  %u" },
				r = "Recurring",
				rd = { description = "Daily", template = "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a> +1d>" },
				rw = { description = "Weekly", template = "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a> +1w>" },
				rm = { description = "Monthly", template = "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a> +1m>" },
			},
			mappings = {
				org = {
					org_toggle_checkbox = "<C-space>",
				org_schedule = ",s",
				org_deadline = ",d",
				},
			},
			ui = {
				menu = {
					handler = function(data)
						Menu:new({
							window = {
								margin = { 1, 0, 1, 0 },
								padding = { 0, 1, 0, 1 },
								title_pos = "center",
								border = "single",
								zindex = 1000,
							},
							icons = {
								separator = "➜",
							},
						}):open(data)
					end,
				},
			},
		})

		require("cmp").setup.filetype("org", {
			sources = {
				{ name = "orgmode" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
		})

		local orgmode_telescope = require("dayem.utils.orgmode_telescope")

		vim.keymap.set("n", "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", { desc = "Org Capture" })
		vim.keymap.set("n", "<leader>oh", orgmode_telescope.search_headings, { desc = "Search Org Headings" })
		vim.keymap.set("n", "<leader>ol", "<cmd>lua require('orgmode').action('org_mappings.insert_link')<CR>", { desc = "Insert Org Link" })
		vim.keymap.set("n", "<leader>or", orgmode_telescope.refile_heading, { desc = "Refile Org Heading" })
		vim.keymap.set("n", "<leader>ona", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local line_num = vim.api.nvim_win_get_cursor(0)[1]
			local line = vim.api.nvim_get_current_line()

			if line:match("^%*+%s+TODO") or line:match("^%*+%s+DONE") then
				local width = math.floor(vim.o.columns * 0.8)
				local height = math.floor(vim.o.lines * 0.6)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				local note_buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_option(note_buf, 'buftype', 'acwrite')
				vim.api.nvim_buf_set_option(note_buf, 'filetype', 'org')

				local win_id = vim.api.nvim_open_win(note_buf, true, {
					relative = 'editor',
					width = width,
					height = height,
					row = row,
					col = col,
					style = 'minimal',
					border = 'rounded',
					title = ' Note for: ' .. line:gsub("^%*+%s+", "") .. ' ',
					title_pos = 'center',
				})

				vim.api.nvim_win_set_option(win_id, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

				vim.api.nvim_buf_set_lines(note_buf, 0, -1, false, { "", "" })
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
							vim.api.nvim_win_close(win_id, true)
						else
							vim.notify("Note is empty, not adding", vim.log.levels.WARN)
						end
					end,
				})
			else
				vim.notify("Cursor must be on a TODO/DONE heading", vim.log.levels.WARN)
			end
		end, { desc = "Add Note to TODO" })

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
