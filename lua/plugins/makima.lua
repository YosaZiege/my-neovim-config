return {
   {
      "folke/tokyonight.nvim",
      opts = {
         style = "night",
         on_colors = function(colors)
            colors.bg = "#1a0e0e"
            colors.fg = "#ffffff"
            colors.red = "#ff4f3e"
            colors.orange = "#ff6b3d"
            colors.yellow = "#ffae42"
         end,
      },
   },
}
