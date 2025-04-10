return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- JS/TS
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.formatting.prettier,

				-- Go
			  -- null_ls.builtins.formatting.goimports,
				-- null_ls.builtins.diagnostics.golangci_lint,
				-- Java

				-- null_ls.builtins.formatting.google_java_format,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
