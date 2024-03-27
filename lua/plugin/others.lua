-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- lualine
require("lualine").setup({
	sections = {
		lualine_c = {
			require("lsp-progress").progress,
		},
	},
	options = {
		theme = "auto",
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha" } },
	},
	extensions = { "neo-tree", "lazy" },
})

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = "lualine_augroup",
	pattern = "LspProgressStatusUpdated",
	callback = require("lualine").refresh,
})

-- trouble
local trouble = require("trouble")

vim.keymap.set("n", "<leader>q", function()
	trouble.open("document_diagnostics")
end)
vim.keymap.set("n", "<leader>xw", function()
	trouble.open("workspace_diagnostics")
end)

-- null ls
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.spectral,

		null_ls.builtins.diagnostics.eslint_d.with({
			extra_filetypes = { "svelte" },
		}),

		null_ls.builtins.diagnostics.pylint,
	},
})

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

require("neo-tree").setup({
	filesystem = {
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
	},
})

-- indent line
require("ibl").setup({
	scope = { enabled = false },
	indent = { char = "│" },
})
