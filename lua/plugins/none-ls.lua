return {
   "nvimtools/none-ls.nvim",
   config = function()
      local null_ls = require("null-ls")
      local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true })

      null_ls.setup({
         sources = {
            -- Lua
            null_ls.builtins.formatting.stylua,

            -- JS/TS
            null_ls.builtins.formatting.prettierd,

            -- Go
            null_ls.builtins.formatting.goimports_reviser,
            null_ls.builtins.formatting.golines,
            null_ls.builtins.formatting.gofmt,
         },

         on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
               vim.keymap.set("n", "<Leader>f", function()
                  vim.lsp.buf.format({ bufnr = bufnr })
               end, { buffer = bufnr, desc = "Format file" })

               -- Format on save
               vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
               vim.api.nvim_create_autocmd("BufWritePre", {
                  group = group,
                  buffer = bufnr,
                  callback = function()
                     vim.lsp.buf.format({
                        bufnr = bufnr,
                        async = false, -- Use synchronous formatting for pre-save
                        filter = function(format_client)
                           -- Prefer null-ls if available
                           return format_client.name == "null-ls"
                        end,
                     })
                  end,
                  desc = "Auto format on save",
               })
            end
         end,
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format with LSP" })
   end,
}
