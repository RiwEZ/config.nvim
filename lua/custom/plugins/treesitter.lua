return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- Additional file types
    vim.treesitter.language.register("templ", "templ")
    vim.treesitter.language.register("typespec", "typespec")

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
        "templ",
      },
      auto_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      sync_install = false,
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
  end,
}
