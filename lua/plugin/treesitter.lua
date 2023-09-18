-- Tree sitter

local treesitter = require 'nvim-treesitter';

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "rust", "go", "svelte" },
	auto_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true }
}
