local js_fmt = { "prettierd", "prettier" }
local formatters_by_ft = {
  lua = { "stylua" },
  javascript = js_fmt,
  typescript = js_fmt,
  typescriptreact = js_fmt,
  svelte = js_fmt,
  vue = js_fmt,
  astro = js_fmt,
  css = js_fmt,
  rust = { "rustfmt" },
  go = { "gofmt" },
  proto = { "buf" },
  jsonc = js_fmt,
  templ = { "templ" },
  sql = { "sleek" },
  json = { "jq" },
  python = { "black" }
}

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
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
              { async = true, timeout_ms = 3000, lsp_fallback = true, stop_after_first = true },
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
    { 'saghen/blink.cmp' }
  },
  config = function()
    /*
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = 'rounded' }
    )
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = 'rounded' }
    )
    */

    vim.diagnostic.config({
      float = {
        border = 'rounded'
      }
    })

    local lspconfig_defaults = require('lspconfig').util.default_config
    --lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    --  'force',
    --  lspconfig_defaults.capabilities,
    --  require('blink.cmp').get_lsp_capabilities(lspconfig_defaults.capabilities)
    -- )

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
      end,

    })

    require("mason").setup({})

    -- https://github.com/sveltejs/language-tools/issues/2008
    local capabilities = lspconfig_defaults.capabilities

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

    vim.lsp.config('svelte', {
      capabilities = copied_capabilities,
    })


    vim.lsp.config('denols', require('custom/lsp/denols'))
    vim.lsp.config("ts_ls", require('custom/lsp/ts_ls'))


    vim.lsp.enable({ 'denols', 'svelte' })
    -- require('lspconfig').gleam.setup({})

    require("mason-lspconfig").setup({
      automatic_enable = true,
      automatic_installation = false,
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "ts_ls",
      },
    })
  end,
}
