require("neodev").setup({})

local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })

	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
	vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation)
	vim.keymap.set("n", "go", vim.lsp.buf.type_definition)
	vim.keymap.set("n", "gr", vim.lsp.buf.references)
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)
end)

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"tsserver",
		"svelte",
		"jedi_language_server",
		"gopls",
		"tailwindcss",
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

--[[
local client = vim.lsp.start_client({
	name = "open_api_lsp",
	cmd = { "/home/tanat/projects/open-api-lsp/open-api-lsp" },
})

if not client then
  vim.notify "smthing wrong"
  return
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function ()
    vim.lsp.buf_attach_client(0, client)
  end
})

]]
--

vim.filetype.add({
	extension = {
		tsp = "tsp",
	},
})

local client = vim.lsp.start_client({
	name = "typespec_lsp",
	cmd = { "tsp-server", "--stdio" },
})

if not client then
	vim.notify("smthing wrong")
	return
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tsp",
	callback = function()
		vim.lsp.buf_attach_client(0, client)
	end,
})

