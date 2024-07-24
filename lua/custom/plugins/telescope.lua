return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		local t = require("telescope.builtin")
		vim.keymap.set("n", "<leader>gf", t.git_files, {})
		vim.keymap.set("n", "<leader>sf", t.find_files, {})
		vim.keymap.set("n", "<leader>sg", t.live_grep, {})
		vim.keymap.set("n", "<leader>/", function()
			t.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, {})
		vim.keymap.set("n", "<leader>?", t.oldfiles, {})
	end,
}
