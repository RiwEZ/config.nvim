-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- lualine
require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha" } },
	},
	extensions = { "neo-tree", "lazy" },
})

-- trouble
local trouble = require("trouble")

vim.keymap.set("n", "<leader>q", function()
	trouble.open("document_diagnostics")
end)
vim.keymap.set("n", "<leader>xw", function()
	trouble.open("workspace_diagnostics")
end)

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>b", mark.add_file)
vim.keymap.set("n", "<S-e>", ui.toggle_quick_menu)

-- fold
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
})
