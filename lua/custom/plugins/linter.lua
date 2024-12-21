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
      python = { "pylint" },
      proto = { "buf" },
    }

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })

    local lint_progress = function()
      local linters = lint.get_running()
      if #linters == 0 then
        return "󰦕"
      end
      return "󰦕 " .. table.concat(linters, ", ")
    end

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
      print(lint_progress())
    end)
  end,
}
