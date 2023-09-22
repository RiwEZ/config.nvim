-- Tree sitter

require 'nvim-treesitter';

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "rust", "go", "svelte" },
  auto_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },

  move = {
    enable = true,
    set_jumps = true,
    goto_next_start = {
      [']m'] = '@function.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
    },
  }
}
