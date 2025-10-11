return {
   "3rd/image.nvim",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
   },
   config = function()
      require("image").setup {
         backend = "kitty", -- choose your terminal backend: kitty, ueberzug, or sixel
      }


      vim.keymap.set({"n", "v"}, "<leader>vi", function()
         local line = vim.fn.getline(".")
         local img = line:match("%((.-)%)")
         if img then
            vim.fn.jobstart({ "xdg-open", img }, { detach = true })
         else
            print("No image found in this line.")
         end
      end, { desc = "Open image under cursor" })
   end,
}
