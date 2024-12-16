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
      require("nvim-dap-virtual-text").setup({})

      local dap = require("dap")
      local ui = require("dapui")
      local neo_tree_cmd = require("neo-tree.command")

      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

      dap.set_log_level('TRACE')

      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        }
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Attach",
          mode = "local",
          request = "attach",
          processId = require 'dap.utils'.pick_process
        },
      }

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = '$HOME/.local/share/nvim/mason/bin/js-debug-adapter',
          args = { "${port}" }
        }
      }
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Vitest File",
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
          program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
          args = { "run", "${file}" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require 'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        }
      }

      dap.adapters.php = {
        type = "executable",
        command = 'php-debug-adapter'
      }

      dap.configurations.php = { {
        name = "debug serve",
        type = "php",
        request = "launch",
        port = 9003,
      } }

      vim.keymap.set("n", "<leader>;", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>.", function()
        ui.toggle()
        neo_tree_cmd.execute({ action = "close" })
      end)
      -- vim.keymap.set("n", "<space>g;", dap.run_to_cursor)

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
