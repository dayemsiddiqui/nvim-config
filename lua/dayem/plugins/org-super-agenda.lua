return {
	"hamidi-dev/org-super-agenda.nvim",
	dependencies = {
		"nvim-orgmode/orgmode",
		"nvim-telescope/telescope.nvim",
	},
	cmd = { "OrgSuperAgenda" },
	keys = {
		{ "<leader>oa", "<cmd>OrgSuperAgendaSafe<cr>", desc = "Org Super Agenda" },
		{ "<leader>oA", "<cmd>OrgSuperAgendaSafe!<cr>", desc = "Org Super Agenda (Fullscreen)" },
	},
	config = function()
		local function close_existing_agenda_buffers()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) then
					local name = vim.api.nvim_buf_get_name(buf)
					if name:match("Org Super Agenda") or name:match("org%-super%-agenda") then
						pcall(vim.api.nvim_buf_delete, buf, { force = true })
					end
				end
			end
		end

		vim.api.nvim_create_user_command("OrgSuperAgendaSafe", function(opts)
			close_existing_agenda_buffers()
			vim.cmd(opts.bang and "OrgSuperAgenda!" or "OrgSuperAgenda")
		end, { bang = true })

		require("org-super-agenda").setup({
			org_directories = { "~/orgfiles" },

			todo_states = {
				{ name = "TODO", keymap = "ot", color = "#FF5555", strike_through = false },
				{ name = "PROGRESS", keymap = "op", color = "#FFAA00", strike_through = false },
				{ name = "WAITING", keymap = "ow", color = "#BD93F9", strike_through = false },
				{ name = "DONE", keymap = "od", color = "#50FA7B", strike_through = true },
			},

			window = {
				width = 0.8,
				height = 0.7,
				border = "rounded",
				title = "Org Super Agenda",
				title_pos = "center",
			},

			groups = {
				{
					name = "📅 Today",
					matcher = function(i)
						return i.scheduled and i.scheduled:is_today()
					end,
					sort = { by = "priority", order = "desc" },
				},
				{
					name = "🗓️ Tomorrow",
					matcher = function(i)
						return i.scheduled and i.scheduled:days_from_today() == 1
					end,
				},
				{
					name = "☠️ Deadlines",
					matcher = function(i)
						return i.deadline and i.todo_state ~= "DONE"
					end,
					sort = { by = "deadline", order = "asc" },
				},
				{
					name = "⭐ Important",
					matcher = function(i)
						return i.priority == "A"
					end,
					sort = { by = "date_nearest", order = "asc" },
				},
				{
					name = "⏳ Overdue",
					matcher = function(i)
						return i.todo_state ~= "DONE"
							and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
					end,
					sort = { by = "date_nearest", order = "asc" },
				},
				{
					name = "🏠 Personal",
					matcher = function(i)
						return i:has_tag("personal")
					end,
				},
				{
					name = "💼 Work",
					matcher = function(i)
						return i:has_tag("work")
					end,
				},
				{
					name = "📆 Upcoming",
					matcher = function(i)
						local days = 10
						local d1 = i.deadline and i.deadline:days_from_today()
						local d2 = i.scheduled and i.scheduled:days_from_today()
						return (d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days)
					end,
					sort = { by = "date_nearest", order = "asc" },
				},
			},

			upcoming_days = 10,
			hide_empty_groups = true,
			allow_duplicates = false,
			show_tags = true,
			show_filename = true,
			heading_max_length = 70,
			view_mode = "classic",

			group_sort = { by = "date_nearest", order = "asc" },
		})
	end,
}
