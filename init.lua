vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw by default
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
	{
		"mbbill/undotree",
	},
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
		},
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				config = function()
					local ls = require("luasnip")
					local t = ls.text_node
					local i = ls.insert_node
					local fmt = require("luasnip.extras.fmt").fmt
					local rep = require("luasnip.extras").rep
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
						s("br", t({ "<br>", "" })),
					})
				end,
			},
			{ "saadparwaiz1/cmp_luasnip" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			use_diagnostic_signs = false,
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<C-n>",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					follow_current_file = { enabled = true },
					-- use_libuv_file_watcher = true,
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			marks = true,
			registers = true,
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
		main = "ibl",
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		event = "VeryLazy",
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth",
		opts = {
			panel = { enabled = false },
			suggestion = { enabled = false },
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"onsails/lspkind.nvim",
	},
	{ "folke/neodev.nvim", opts = {} },
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ timeout_ms = 3000 })
				end,
				mode = "n",
				desc = "Format current buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				svelte = { { "prettierd", "prettier" } },
				astro = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				rust = { "rustfmt" },
				go = { "gofmt" },
			},
			log_level = vim.log.levels.INFO,
		},
	},
	require("plugin/linter"),
})

require("remap")
require("options")
require("plugin/color")
require("plugin/telescope")
require("plugin/treesitter")
require("plugin/lsp")
require("plugin/autocomplete")
require("plugin/others")
require("which-key")
require("gitsigns").setup()
