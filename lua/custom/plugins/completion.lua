return {
  "saghen/blink.cmp",
  lazy = false,
  version = "v0.*",
  dependencies = {
    { "onsails/lspkind.nvim" },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")
        local t = ls.text_node
        local i = ls.insert_node
        local s = ls.snippet

        -- markdown figure for my blog
        ls.add_snippets("markdown", {
          s({
            trig = "figure",
          }, {
            t({
              "<figure>",
              '<img src="" loading="lazy" />',
              "<figcaption>",
              "<center>",
            }),
            i(1, "Lorem"),
            t({
              "</center>",
              "</figcaption>",
              "</figure>",
            }),
          }),
          s({
            trig = "video",
          }, {
            t({
              "<figure>",
              '<video controls="true" />',
              '<source src="" type="video/mp4">',
              "</video>",
              "<figcaption>",
              "<center>",
            }),
            i(1, "Lorem"),
            t({
              "</center>",
              "</figcaption>",
              "</figure>",
            }),
          }),
          s("br", t({ "<br>", "" })),
        })
      end,
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'enter' },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono'
    },
    snippets = {
      expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction) require('luasnip').jump(direction) end,
    },
    sources = {
      default = { 'lsp', 'path', 'luasnip', 'buffer' },
      cmdline = {},
    },
  }
}
