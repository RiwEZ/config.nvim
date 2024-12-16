local js_fmt = { "biome", "prettierd", "prettier" }
local formatters_by_ft = {
  lua = { "stylua" },
  javascript = js_fmt,
  typescript = js_fmt,
  typescriptreact = js_fmt,
  svelte = js_fmt,
  vue = { "prettierd", "prettier" },
  astro = { "prettierd", "prettier" },
  css = js_fmt,
  rust = { "rustfmt" },
  go = { "gofmt" },
  proto = { "buf" },
  jsonc = js_fmt,
  templ = { "templ" },
  sql = { "sleek" },
  json = { "jq" }
}

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    { "folke/neodev.nvim",                opts = {} },
    { "VonHeikemen/lsp-zero.nvim",        branch = "v3.x", lazy = false },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      keys = {
        {
          "<leader>fm",
          function()
            require("conform").format(
              { async = true, timeout_ms = 3000, lsp_fallback = true },
              function(err)
                if not err then
                  local mode = vim.api.nvim_get_mode().mode
                  if vim.startswith(string.lower(mode), "v") then
                    vim.api.nvim_feedkeys(
                      vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true
                    )
                  end
                end
              end)
          end,
          mode = "",
          desc = "Format current buffer",
        },
      },
      opts = {
        formatters_by_ft = formatters_by_ft,
        log_level = vim.log.levels.INFO,
      },
    },
  },
  config = function()
    require("neodev").setup({})

    local lsp_zero = require("lsp-zero")
    lsp_zero.extend_lspconfig()
    lsp_zero.on_attach(function(_, bufnr)
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
        "ts_ls",
        "gopls",
      },
      handlers = {
        lsp_zero.default_setup,
        svelte = function()
          -- https://github.com/sveltejs/language-tools/issues/2008
          local capabilities = lsp_zero.get_capabilities()

          -- create a new capabilities with didChangeWatchedFiles that is not referenced from the lsp_zero one
          local copied_capabilities = {}
          for k, v in pairs(capabilities) do
            if k == "workspace" then
              local workspace = { didChangeWatchedFiles = false }
              for _k, _v in pairs(capabilities[k]) do
                if _k ~= "didChangeWatchedFiles" then
                  workspace[_k] = _v
                end
              end
              copied_capabilities[k] = workspace
            else
              copied_capabilities[k] = v
            end
          end

          require("lspconfig").svelte.setup({
            capabilities = copied_capabilities,
          })
        end,
        volar = lsp_zero.noop,
        ts_ls = function()
          local lspconfig = require("lspconfig")

          local mason_registry = require("mason-registry")
          local vue_language_server_path = mason_registry
              .get_package("vue-language-server")
              :get_install_path() .. "/node_modules/@vue/language-server"

          lspconfig.ts_ls.setup({
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                },
              },
            },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
            },
          })
          lspconfig.volar.setup({})
        end,
      },
    })

    require('java').setup()
  end,
}
