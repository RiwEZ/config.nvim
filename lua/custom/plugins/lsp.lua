local js_fmt = { { "biome", "prettierd", "prettier" } }
local formatters_by_ft = {
	lua = { "stylua" },
	javascript = js_fmt,
	typescript = js_fmt,
	typescriptreact = js_fmt,
	svelte = js_fmt,
	astro = { { "prettierd", "prettier" } },
	css = js_fmt,
	rust = { "rustfmt" },
	go = { "gofmt" },
	proto = { "buf" },
	jsonc = js_fmt,
}

return {
	"neovim/nvim-lspconfig",
  lazy = false,
	dependencies = {
		{ "folke/neodev.nvim", opts = {} },
		{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x", lazy = false },
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
						require("conform").format({ timeout_ms = 3000, lsp_fallback = true })
					end,
					mode = "n",
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

		lsp_zero.on_attach(function(client, bufnr)
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
				"tsserver",
				"svelte",
				"jedi_language_server",
				"gopls",
				"tailwindcss",
			},
			handlers = {
				lsp_zero.default_setup,
			},
		})

		--[[
      local client = vim.lsp.start_client({
        name = "open_api_lsp",
        cmd = { "/home/tanat/projects/open-api-lsp/open-api-lsp" },
      })

      if not client then
        vim.notify "smthing wrong"
        return
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "yaml",
        callback = function ()
          vim.lsp.buf_attach_client(0, client)
        end
      })
    --]]
	end,
}
