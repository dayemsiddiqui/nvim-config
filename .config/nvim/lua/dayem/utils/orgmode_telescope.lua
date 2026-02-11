local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local M = {}

function M.search_headings()
	local orgmode_api = require("orgmode.api")
	local files = orgmode_api.load()

	local results = {}

	for _, file in ipairs(files) do
		if file.headlines then
			for _, headline in ipairs(file.headlines) do
				table.insert(results, {
					filename = file.filename,
					lnum = headline.position.start_line,
					level = headline.level,
					title = headline.title,
					display_text = string.format("%s %s", string.rep("*", headline.level), headline.title),
				})
			end
		end
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 30 },
			{ remaining = true },
		},
	})

	local function make_display(entry)
		local filename = vim.fn.fnamemodify(entry.filename, ":t")
		return displayer({
			string.format("%s:%d", filename, entry.lnum),
			entry.display_text,
		})
	end

	pickers
		.new({}, {
			prompt_title = "Search Org Headings",
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						filename = entry.filename,
						lnum = entry.lnum,
						ordinal = entry.filename .. " " .. entry.display_text,
						display = make_display,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.grep_previewer({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.cmd("edit " .. selection.filename)
					vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
				end)
				return true
			end,
		})
		:find()
end

function M.refile_heading()
	if vim.bo.filetype ~= "org" then
		vim.notify("Not in an org file", vim.log.levels.WARN)
		return
	end

	require("orgmode").action("capture.refile_headline_to_destination")
end

return M
