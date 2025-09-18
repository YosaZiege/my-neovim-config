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
      follow_url=true,
      completion = {
         nvim_cmp = true,                    -- Enable nvim-cmp integration
         min_chars = 2,                      -- Number of characters before completion starts
      },
       note_id_func = function(title)
        -- This formats the filename nicely when creating new notes
        local sanitized = title:gsub(" ", "_"):gsub("[^%w_]", "")
        return sanitized
    end,
   },
}
