return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup()
		vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
		-- Close terminal (while in terminal mode)
		vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })

		-- Alternative: Close terminal with Esc (while in terminal mode)
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n><cmd>ToggleTerm<CR>", { noremap = true, silent = true })
	end,
}
