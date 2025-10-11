return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
         auto_install = true,
         ensure_installed = { "markdown", "markdown_inline", "lua", "python", "c", "go" },
         highlight = { enable = true },
         indent = { enable = true },
      })
   end,
}
