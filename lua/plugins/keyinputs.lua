return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify"
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup"
    },
    messages = {
      enabled = true
    },
    popupmenu = {
      enabled = true
    },
    -- This shows your keystrokes!
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
    -- Enable showcmd to see keystrokes
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
    -- This is the key part for showing keystrokes
    presets = {
      bottom_search = true,         -- use a classic bottom cmdline for search
      command_palette = true,        -- position the cmdline and popupmenu together
      long_message_to_split = true,  -- long messages will be sent to a split
      inc_rename = false,            -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,        -- add a border to hover docs and signature help
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    -- Enable vim's showcmd option to display keystrokes
    vim.o.showcmd = true
  end
}
