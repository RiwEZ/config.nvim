return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "onsails/lspkind.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    {
      "L3MON4D3/LuaSnip",
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
            trigEngine = "pattern",
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
            trigEngine = "pattern",
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
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function()
    local cmp = require("cmp")

    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    local lspkind = require("lspkind")
    lspkind.init({
      symbol_map = {
        Copilot = "",
      },
    })
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      sources = {
        {
          name = "nvim_lsp",

          -- https://github.com/vuejs/language-tools/discussions/4495
          ---@param entry cmp.Entry
          ---@param ctx cmp.Context
          entry_filter = function(entry, ctx)
            if ctx.filetype ~= "vue" then
              return true
            end
            local cursor_before_line = ctx.cursor_before_line
            if cursor_before_line:sub(-1) == "@" then
              return entry.completion_item.label:match("^@")
            elseif cursor_before_line:sub(-1) == ":" then
              return entry.completion_item.label:match("^:")
                  and not entry.completion_item.label:match("^:on-")
            else
              return true
            end
          end,
        },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      },
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
