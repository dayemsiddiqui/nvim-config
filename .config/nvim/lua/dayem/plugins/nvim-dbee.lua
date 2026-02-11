return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		require("dbee").install()
	end,
	config = function()
		local dbee = require("dbee")

		dbee.setup({
			sources = {
				require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
				require("dbee.sources").FileSource:new(vim.fn.stdpath("config") .. "/dbee/connections.json"),
			},
			extra_helpers = {
				["mine"] = {
					mysql = "SELECT * FROM {table} LIMIT 10;",
					postgres = "SELECT * FROM {table} LIMIT 10;",
				},
			},
		})

		vim.keymap.set("n", "<leader>db", function()
			dbee.toggle()
		end, { desc = "Toggle Dbee UI" })

		vim.keymap.set("n", "<leader>de", function()
			dbee.execute()
		end, { desc = "Execute query" })
	end,
}
