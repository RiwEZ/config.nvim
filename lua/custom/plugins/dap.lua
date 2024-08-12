return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("dapui").setup()
			require("dap-go").setup()
			require("nvim-dap-virtual-text").setup(g)

			local dap = require("dap")
			local ui = require("dapui")
			local neo_tree_cmd = require("neo-tree.command")

			vim.keymap.set("n", "<space>;", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>g;", dap.run_to_cursor)

			-- Evaluate variable under cursor
			-- vim.keymap.set("n", "<space>?", function()
			-- require("dapui").eval(nil, { enter = true })
			-- end)

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F13>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
				neo_tree_cmd.execute({ action = "close" })
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
				neo_tree_cmd.execute({ action = "close" })
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
