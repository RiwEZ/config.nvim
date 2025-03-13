return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  opts = {
    events = { "BufWritePost", "BufReadPost" },
  },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function(_, opts)
    local lint = require("lint")

    local js_linters = { "eslint_d" }
    lint.linters_by_ft = {
      -- php = { "phpstan" },
      go = { "golangcilint" },
      fish = { "fish" },
      svelte = js_linters,
      vue = js_linters,
      javascript = js_linters,
      typescript = js_linters,
      typescriptreact = js_linters,
      -- python = { "pylint" },
      proto = { "buf" },
    }

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        local client = vim.lsp.get_clients({ bufnr = 0 })[1] or {}
        if client ~= {} then
          lint.try_lint(nil, { cwd = client.root_dir })
        else
          lint.try_lint()
        end
      end,
    })

    local lint_progress = function()
      local linters = lint.get_running()
      if #linters == 0 then
        return "no linters"
      end
      return "󰦕 " .. table.concat(linters, ", ")
    end

    -- linter debug keybind
    vim.keymap.set("n", "<leader>l", function()
      local client = vim.lsp.get_clients({ bufnr = 0 })[1] or {}
      lint.try_lint(nil, { cwd = client.root_dir })
      print(lint_progress())
    end)
  end,
}
