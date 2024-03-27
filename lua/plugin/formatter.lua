local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { { "prettierd", "prettier" } },
		svelte = { { "prettierd", "prettier" } },
		rust = { "rustfmt" },
		go = { "gofmt" },
	},
})

vim.keymap.set("n", "<leader>fm", function()
	conform.format({ timeout_ms = 3000 })
end)
