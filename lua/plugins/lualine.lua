return {
   "nvim-lualine/lualine.nvim",
   config = function()
      -- Custom red/orange theme
      local red_orange = {
         normal = {
            a = { fg = "#1e1e2e", bg = "#ff6b3d", gui = "bold" }, -- bright orange
            b = { fg = "#ffffff", bg = "#b43e2a" },       -- deep red
            c = { fg = "#ffffff", bg = "#2b2b2b" },
         },
         insert = {
            a = { fg = "#1e1e2e", bg = "#ff4f4f", gui = "bold" }, -- bright red
            b = { fg = "#ffffff", bg = "#c7382f" },
            c = { fg = "#ffffff", bg = "#2b2b2b" },
         },
         visual = {
            a = { fg = "#1e1e2e", bg = "#ff9153", gui = "bold" }, -- soft orange
            b = { fg = "#ffffff", bg = "#b43e2a" },
            c = { fg = "#ffffff", bg = "#2b2b2b" },
         },
         replace = {
            a = { fg = "#1e1e2e", bg = "#ff3b3b", gui = "bold" },
            b = { fg = "#ffffff", bg = "#b43e2a" },
            c = { fg = "#ffffff", bg = "#2b2b2b" },
         },
         command = {
            a = { fg = "#1e1e2e", bg = "#ff7a32", gui = "bold" },
            b = { fg = "#ffffff", bg = "#b43e2a" },
            c = { fg = "#ffffff", bg = "#2b2b2b" },
         },
         inactive = {
            a = { fg = "#888888", bg = "#2b2b2b" },
            b = { fg = "#888888", bg = "#2b2b2b" },
            c = { fg = "#888888", bg = "#2b2b2b" },
         },
      }
      require("lualine").setup({
         options = {
            theme = red_orange,
            icons_enabled = true,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
         },
      })
   end,
}
