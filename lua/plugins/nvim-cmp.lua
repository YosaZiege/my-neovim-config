return {
   "hrsh7th/nvim-cmp",
   event = "InsertEnter",
   dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
   },
   config = function()
      local cmp = require("cmp")

      cmp.setup({
         snippet = {
            expand = function(args)
               vim.fn["vsnip#anonymous"](args.body)
            end,
         },
         mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
         }),
         sources = cmp.config.sources({
            { name = "obsidian" }, -- [[link]] and #tag completions
            { name = "nvim_lsp" },
            { name = "vsnip" },
         }, {
            { name = "buffer" },
            { name = "path" },
         }),
         window = {
            -- Uncomment for bordered windows:
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
         },
      })

      -- Cmdline setup for '/' and '?'
      cmp.setup.cmdline({ "/", "?" }, {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
            { name = "buffer" }
         }
      })

      -- Cmdline setup for ':'
      cmp.setup.cmdline(":", {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({
            { name = "path" }
         }, {
            { name = "cmdline" }
         }),
         matching = { disallow_symbol_nonprefix_matching = false }
      })

      -- LSP capabilities integration
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Example of LSP server setup
      local lspconfig = require("lspconfig")
      local servers = { "lua_ls", "pyright", "ts_ls" } -- Replace with your servers

      for _, server in ipairs(servers) do
         lspconfig[server].setup({
            capabilities = capabilities,
         })
      end
   end,
}
