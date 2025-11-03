return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-mini/mini.nvim", -- if you use the mini.nvim suite
			-- or "nvim-mini/mini.icons" for standalone
			-- or "nvim-tree/nvim-web-devicons" if you prefer devicons
		},
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
