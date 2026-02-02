return {
   "catppuccin/nvim",
   name = "catppuccin",
   priority = 1000,
   config = function()
      require("catppuccin").setup({
         flavour = "mocha",
         color_overrides = {
            mocha = {
               base = "#1e1a1a",
               mantle = "#211b1b",
               crust = "#181414",
               peach = "#ffb86c", -- orange accents
               red = "#ff5555", -- vibrant red
            },
         },
         highlight_overrides = {
            mocha = function(colors)
               return {
                  CursorLine = { bg = colors.crust },
                  Visual = { bg = colors.red },
                  LineNr = { fg = colors.peach },
                  CursorLineNr = { fg = colors.red, bold = true },
               }
            end,
         },
      })

      vim.cmd.colorscheme("catppuccin")
   end,
}
