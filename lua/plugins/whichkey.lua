return {
   "NStefan002/screenkey.nvim",
   cmd = "Screenkey",
   version = "*",
   config = function()
      require("screenkey").setup({
         win_opts = {
            relative = "editor",
            anchor = "SE",
            width = 40,
            height = 3,
            border = "rounded",
         },
         compress_after = 3,
         clear_after = 3,
         disable = {
            filetypes = {},
            buftypes = {},
         },
         show_leader = true,
         group_mappings = true,
         display_infront = {},
         display_behind = {},
         filter = function(keys)
            return keys
         end,
         keys = {
            ["<TAB>"] = "󰌒",
            ["<CR>"] = "󰌑",
            ["<ESC>"] = "Esc",
            ["<SPACE>"] = "␣",
            ["<BS>"] = "󰁮",
            ["<DEL>"] = "Del",
            ["<LEFT>"] = "",
            ["<RIGHT>"] = "",
            ["<UP>"] = "",
            ["<DOWN>"] = "",
            ["<HOME>"] = "Home",
            ["<END>"] = "End",
            ["<PAGEUP>"] = "PgUp",
            ["<PAGEDOWN>"] = "PgDn",
         },
      })
      -- Optionally auto-start
      -- vim.cmd("Screenkey")
   end,
}
