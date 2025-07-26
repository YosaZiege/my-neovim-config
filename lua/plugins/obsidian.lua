return {
   "epwalsh/obsidian.nvim",
   version = "*",
   lazy = true,
   ft = "markdown",
   dependencies = {
      "nvim-lua/plenary.nvim",
      -- Optional but recommended for completion
      "hrsh7th/nvim-cmp",
   },
   opts = {
      workspaces = {
         {
            name = "work",
            path = "~/Documents",
         },
      },

      new_notes_location = "current_dir",    -- New notes when completing [[link]]
      completion = {
         nvim_cmp = true,                    -- Enable nvim-cmp integration
         min_chars = 2,                      -- Number of characters before completion starts
      },
   },
}
