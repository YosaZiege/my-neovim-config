return {
   {
      "williamboman/mason.nvim",
      config = function()
         require("mason").setup()
      end
   },
   {
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup({
            "ast_grep",
            "css_variables",
            "docker_compose_language_service", 
            "golangci_lint_ls",
            "html",
            "java_language_server",
            "ts_ls",
            "eslint",
            "jsonls",
            "lua_ls",
            "pylsp",
            "sqlls",
            "ts_ls",
         })
      end
   },
   {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.ts_ls.setup({})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
    end
   }
}
