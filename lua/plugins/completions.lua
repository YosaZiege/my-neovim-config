return {
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp", -- LSP completions
         "L3MON4D3/LuaSnip",
         "saadparwaiz1/cmp_luasnip",
         "rafamadriz/friendly-snippets",
      },
      config = function()
         local cmp = require("cmp")
         require("luasnip.loaders.from_vscode").lazy_load()

         cmp.setup({
            snippet = {
               expand = function(args)
                  require("luasnip").lsp_expand(args.body)
               end,
            },
            mapping = cmp.mapping.preset.insert({
               ["<C-Space>"] = cmp.mapping.complete(),
               ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
               { name = "nvim_lsp" }, -- This enables LSP-based completions (including Tailwind)
               { name = "luasnip" },
            }, {
               { name = "buffer" },
            }),
         })
      end,
   },
}
