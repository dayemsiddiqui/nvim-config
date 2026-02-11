return {
	"michaelb/sniprun",
	build = "bash install.sh",
	cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean" },
	config = function()
		require("sniprun").setup({
			display = { "Classic" },
			interpreter_options = {
				OrgMode_original = {
					use_on_filetypes = { "org" },
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>or", "<cmd>SnipRun<CR>", { desc = "Run Code Block" })
		vim.keymap.set("n", "<leader>oR", "<cmd>SnipReset<CR>", { desc = "Reset Sniprun" })
	end,
}
