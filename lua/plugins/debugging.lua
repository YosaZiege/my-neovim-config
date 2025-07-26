return {
   "mfussenegger/nvim-dap",
   dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
   },
   config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dapgo = require("dap-go")

      -- Setup dap-ui
      dapui.setup()

      -- Setup dap-go (uses delve under the hood)
      dapgo.setup()

      -- Automatically open and close dap-ui
      dap.listeners.before.attach.dapui_config = function()
         dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
         dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
         dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
         dapui.close()
      end

      -- Keybindings for common DAP actions
      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<Leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<Leader>do", dap.step_over, opts)
      vim.keymap.set("n", "<Leader>dr", dap.restart, opts)
      vim.keymap.set("n", "<Leader>dq", dap.terminate, opts)

      -- Open dap-ui manually
      vim.keymap.set("n", "<Leader>dus", function()
         dapui.toggle({})
      end, opts)
   end,
 }
