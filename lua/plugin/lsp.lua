local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format { timeout_ms = 5000 } end)
vim.keymap.set('n', '<leader>f', vim.diagnostic.open_float)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation)
vim.keymap.set('n', 'go', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })
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
    "ocamllsp",
    "clangd"
  },
  handlers = {
    lsp_zero.default_setup,
  },
})
