return {
  "ray-x/go.nvim",
  dependencies = {"ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter"},
  ft = {"go", "gomod"},
  config = function()
    require("go").setup()
  end,
}

