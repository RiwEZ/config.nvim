-- Tree sitter

require("nvim-treesitter")

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"javascript",
		"typescript",
		"rust",
		"go",
		"svelte",
		"python",
		"ocaml",
		"css",
		"cpp",
	},
	auto_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },

	move = {
		enable = true,
		set_jumps = true,
		goto_next_start = {
			["]m"] = "@function.outer",
		},
		goto_next_end = {
			["]M"] = "@function.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
		},
	},
})

--[[
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.cpelang = {
	install_info = {
		url = "~/projects/compiler/tree-sitter-cpelang",
		files = { "src/parser.c" },
	},
	filetype = "cpe",
}

vim.filetype.add({
	extension = {
		cpe = "cpe",
	},
})
--]]
