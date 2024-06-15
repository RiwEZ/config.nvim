-- telescope config
return function()
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
end
