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
				"ast_grep",
				"css_variables",
				"docker_compose_language_service",
				"golangci_lint_ls",
				"html-lsp",
				"css-lsp",
				"java_language_server",
				"ts_ls",
				"eslint",
				"jsonls",
				"lua_ls",
				"pylsp",
				"sqlls",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilites = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilites = capabilities,
			})
			lspconfig.gopls.setup({
				capabilites = capabilities,
			})
			lspconfig.html.setup({
				capabilites = capabilities,
			})
			lspconfig.css_variables.setup({
				capabilites = capabilities,
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
