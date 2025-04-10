return {
   {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         require("telescope").setup({})
         local builtin = require("telescope.builtin")
         vim.keymap.set("n", "<C-p>", builtin.find_files, {})
         vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      end,
   },
   {
      "nvim-telescope/telescope-ui-select.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
         require("telescope").setup({
            extensions = {
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
            },
         })
         require("telescope").load_extension("ui-select")
      end,
   },
}
