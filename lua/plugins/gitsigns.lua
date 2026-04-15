-- gitsigns.lua
-- Git integration: signs in the gutter, hunk navigation, inline blame,
-- stage/reset hunks, and diff views. You had zero git UI before this.

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add          = { text = "▎" },
			change       = { text = "▎" },
			delete       = { text = "" },
			topdelete    = { text = "" },
			changedelete = { text = "▎" },
			untracked    = { text = "▎" },
		},
		-- Show blame info at end of line after cursor is still for updatetime ms
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 500,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns
			local opts = { buffer = bufnr }

			local function map(mode, key, fn, desc)
				vim.keymap.set(mode, key, fn, vim.tbl_extend("force", opts, { desc = "Git: " .. desc }))
			end

			-- ── Hunk navigation ──────────────────────────────────────────────
			map("n", "]h", function()
				if vim.wo.diff then return "]h" end
				vim.schedule(gs.next_hunk)
				return "<Ignore>"
			end, "next hunk")

			map("n", "[h", function()
				if vim.wo.diff then return "[h" end
				vim.schedule(gs.prev_hunk)
				return "<Ignore>"
			end, "prev hunk")

			-- ── Stage / reset ────────────────────────────────────────────────
			map({ "n", "v" }, "<leader>gs", function()
				-- In visual mode, stage only selected lines
				if vim.fn.mode() == "v" then
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				else
					gs.stage_hunk()
				end
			end, "stage hunk")

			map({ "n", "v" }, "<leader>gr", function()
				if vim.fn.mode() == "v" then
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				else
					gs.reset_hunk()
				end
			end, "reset hunk")

			map("n", "<leader>gS", gs.stage_buffer,       "stage buffer")
			map("n", "<leader>gR", gs.reset_buffer,       "reset buffer")
			map("n", "<leader>gu", gs.undo_stage_hunk,    "undo stage hunk")

			-- ── Diff & preview ───────────────────────────────────────────────
			map("n", "<leader>gp", gs.preview_hunk,       "preview hunk")
			map("n", "<leader>gd", gs.diffthis,           "diff this file")
			map("n", "<leader>gD", function()
				gs.diffthis("~")                           -- diff against last commit
			end, "diff against last commit")

			-- ── Blame ────────────────────────────────────────────────────────
			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })             -- full commit info in float
			end, "blame line (full)")
			map("n", "<leader>gB", gs.toggle_current_line_blame, "toggle inline blame")

			-- ── Text object: ih = inner hunk ─────────────────────────────────
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "select hunk (text object)")
		end,
	},
}
