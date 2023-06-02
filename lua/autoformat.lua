
local null_ls = require("null-ls")

null_ls.setup({
  on_attach = function(client, bufnr)
    local function setFormatKeymap(keymapType)
      vim.keymap.set(keymapType, "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), timeout = 2000 })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end

    if client.supports_method("textDocument/formatting") then
      setFormatKeymap("n")
    end

    if client.supports_method("textDocument/rangeFormatting") then
      setFormatKeymap("x")
    end
  end,
})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "javascript",
    "typescript",
  },
})

prettier.setup({
  ["null-ls"] = {
    condition = function()
      return prettier.config_exists({
        -- if `false`, skips checking `package.json` for `"prettier"` key
        check_package_json = true,
      })
    end,
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
  }
})
