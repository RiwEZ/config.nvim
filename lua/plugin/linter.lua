return {
	"mfussenegger/nvim-lint",
	event = "VeryLazy",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	},
	config = function(_, opts)
		local M = {}

		local lint = require("lint")

		-- custom biomejs
		-- based on https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/biomejs.lua
		lint.linters.custom_biomejs = {
			name = "custom_biomejs",
			cmd = function()
				local dirname = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
				local node_folders =
					vim.fs.find("node_modules/.bin/biome", { upward = true, path = dirname })
				for _, result in ipairs(node_folders) do
					if vim.fn.executable(result) == 1 then
						return result
					end
				end
				return "biome"
			end,
			args = { "lint" },
			stdin = false,
			ignore_exitcode = true,
			stream = "both",
			parser = function(output)
				local diagnostics = {}
				local fetch_message = false
				local lnum, col, code, message
				for _, line in ipairs(vim.fn.split(output, "\n")) do
					if fetch_message then
						_, _, message = string.find(line, "%s×(.+)")

						if message then
							message = (message):gsub("^%s+×%s*", "")

							table.insert(diagnostics, {
								source = "biomejs",
								lnum = tonumber(lnum) - 1,
								col = tonumber(col),
								message = message,
								code = code,
							})

							fetch_message = false
						end
					else
						_, _, lnum, col, code = string.find(line, "[^:]+:(%d+):(%d+)%s([%a%/]+)")

						if lnum then
							fetch_message = true
						end
					end
				end

				return diagnostics
			end,
		}

		lint.linters_by_ft = {
			fish = { "fish" },
			svelte = { "eslint_d" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "custom_biomejs" },
			python = { "pylint" },
			proto = { "buf" },
		}

		function M.debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		function M.lint()
			-- Use nvim-lint's logic first:
			-- * checks if linters exist for the full filetype first
			-- * otherwise will split filetype by "." and add all those linters
			-- * this differs from conform.nvim which only uses the first filetype that has a formatter
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)

			-- Add fallback linters.
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end

			-- Add global linters.
			vim.list_extend(names, lint.linters_by_ft["*"] or {})

			-- Filter out linters that don't exist or don't match the condition.
			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			-- Run linters.
			if #names > 0 then
				lint.try_lint(names)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = M.debounce(100, M.lint),
		})
	end,
}
