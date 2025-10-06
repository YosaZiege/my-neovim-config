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
        
        -- Setup dap-go
        dapgo.setup({
            dap_configurations = {
                {
                    type = "go",
                    name = "Debug File",
                    request = "launch",
                    program = "${file}",
                    stopOnEntry = false,  -- Changed from true to false for better UX
                },
                {
                    type = "go",
                    name = "Debug Package",
                    request = "launch",
                    program = "${workspaceFolder}",
                },
                {
                    type = "go",
                    name = "Debug Test",
                    request = "launch",
                    mode = "test",
                    program = "${workspaceFolder}",
                },
            },
            delve = {
                path = "dlv",  -- Use path instead of vim.fn.exepath
                initialize_timeout_sec = 20,
                port = "${port}",
            },
        })
        
        -- Setup dap-ui
        dapui.setup({
            controls = {
                enabled = true,
            },
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        { id = "breakpoints", size = 0.25 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 0.25 },
                    },
                    position = "left",
                    size = 40,
                },
                {
                    elements = {
                        { id = "repl", size = 0.5 },
                        { id = "console", size = 0.5 },
                    },
                    position = "bottom",
                    size = 10,
                },
            },
        })
        
        -- Fixed event listeners
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
        
        -- Keybindings
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, opts)
        vim.keymap.set("n", "<Leader>dc", dap.continue, opts)
        vim.keymap.set("n", "<Leader>do", dap.step_over, opts)
        vim.keymap.set("n", "<Leader>di", dap.step_into, opts)  -- Added step into
        vim.keymap.set("n", "<Leader>dO", dap.step_out, opts)   -- Added step out
        vim.keymap.set("n", "<Leader>dr", dap.restart, opts)
        vim.keymap.set("n", "<Leader>dq", dap.terminate, opts)
        vim.keymap.set("n", "<Leader>dus", function() 
            dapui.toggle({}) 
        end, opts)
        
        -- Additional useful keybindings
        vim.keymap.set("n", "<Leader>dbc", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, opts)
        vim.keymap.set("n", "<Leader>dbl", function()
            dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end, opts)
    end,
}
