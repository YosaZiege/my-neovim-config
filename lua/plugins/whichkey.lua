return {
   "folke/which-key.nvim",
   event = "VeryLazy",
   opts = {
      preset = "modern",      -- "classic" | "modern" | "helix"
      -- Show keys as you type them
      delay = 200,            -- delay before showing the popup (ms)
      plugins = {
         marks = true,        -- shows a list of your marks on ' and `
         registers = true,    -- shows your registers on " in NORMAL or <C-r> in INSERT mode
         spelling = {
            enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
         },
         presets = {
            operators = true,    -- adds help for operators like d, y, ...
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
         },
      },
      win = {
         border = "rounded",       -- none, single, double, shadow, rounded
         position = "bottom",      -- bottom, top
         margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
         padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
         winblend = 0,             -- value between 0-100 0 for fully opaque and 100 for fully transparent
         zindex = 1000,            -- positive value to position WhichKey above other floating windows
      },
      layout = {
         height = { min = 4, max = 25 }, -- min and max height of the columns
         width = { min = 20, max = 50 }, -- min and max width of the columns
         spacing = 3,                    -- spacing between columns
         align = "left",                 -- align columns left, center or right
      },
      show_help = true,                  -- show a help message in the command line for using WhichKey
      show_keys = true,                  -- show the currently pressed key and its label as a message in the command line
      triggers = {
         { "<auto>", mode = "nixsotc" }, -- automatically setup triggers for most keys
      },
   },
   config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Optional: Add custom key group labels
      wk.add({
         { "<leader>f", group = "File/Find" },
         { "<leader>c", group = "Code" },
         { "<leader>g", group = "Git" },
         { "<leader>s", group = "Search" },
         { "<leader>t", group = "Toggle" },
         { "<leader>w", group = "Window" },
         { "<leader>b", group = "Buffer" },
         { "<leader>d", group = "Debug" },
         { "<leader>r", group = "Rename/Replace" },
         { "<leader>l", group = "LSP" },
         { "<leader>h", group = "Hunk/Git" },
         { "<leader>x", group = "Diagnostics/Quickfix" },
      })
   end,
}


