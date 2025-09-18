return {
   {
      "williamboman/mason.nvim",
      config = function()
         require("mason").setup()
      end,
   },
   {
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup({
            ensure_installed = {
               "ast_grep",
               "css_variables",
               "html",
               "tailwindcss",
               "cssls",
               "jdtls",
               "ts_ls",
               "eslint",
               "jsonls",
               "lua_ls",
               "pylsp",
               "sqlls",
               "gopls",
            },
         })
      end,
   },
   {
      "neovim/nvim-lspconfig",
      config = function()
         local capabilities = require("cmp_nvim_lsp").default_capabilities()
         local lspconfig = require("lspconfig")

         lspconfig.lua_ls.setup({
            capabilities = capabilities,
         })
         lspconfig.ts_ls.setup({
            capabilities = capabilities,
         })
         lspconfig.gopls.setup({
            capabilities = capabilities,
            settings = {
               gopls = {
                  completeUnimported = true,
                  usePlaceholders = true,
                  analyses = {
                     unusedparams = true,
                     staticcheck =true,
                     experimentalWorkspaceModule = true,
                  }
               },
            }
         })
         lspconfig.tailwindcss.setup({
            capabilities = capabilities,
         })
         lspconfig.html.setup({
            capabilities = capabilities,
         })
         lspconfig.cssls.setup({
            capabilities = capabilities,
         })
         lspconfig.eslint.setup({
            capabilities = capabilities,
         })
         vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
         vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
         vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      end,
   },
}
