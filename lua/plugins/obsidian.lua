-- obsidian.lua
-- Fixed issues from original:
--   1. note_id_func was outside opts = {} (never applied) — now inside
--   2. Added daily_notes config
--   3. Added templates config
--   4. Added Telescope picker integration
--   5. Added follow_url_func for opening URLs externally
--   6. Added comprehensive keymaps

return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim", -- for the picker
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		workspaces = {
			{
				name = "work",
				path = "~/Documents",
			},
			-- Add more vaults as needed:
			-- {
			--   name = "personal",
			--   path = "~/notes",
			-- },
		},

		-- Where new notes are created when following a [[link]] that doesn't exist
		new_notes_location = "current_dir",

		-- ─── Note ID / naming ──────────────────────────────────────────────────
		-- Fixed: was outside opts in the original, so it was silently ignored.
		-- Now correctly placed inside opts.
		note_id_func = function(title)
			if title then
				-- Replace spaces with underscores, strip special chars
				local sanitized = title:gsub(" ", "_")
				sanitized = sanitized:gsub("[^%w_%-:]", "")
				return sanitized
			else
				-- Fallback: timestamp-based ID for untitled notes
				return tostring(os.time())
			end
		end,

		-- How the note frontmatter [[title]] is derived from the filename
		note_path_func = function(spec)
			local path = spec.dir / tostring(spec.id)
			return path:with_suffix(".md")
		end,

		-- ─── Daily notes ───────────────────────────────────────────────────────
		daily_notes = {
			folder = "Daily",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",  -- "April 9, 2026"
			template = "daily.md",         -- Template file inside your templates folder
		},

		-- ─── Templates ─────────────────────────────────────────────────────────
		templates = {
			folder = "Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- Substitutions available inside template files as {{date}} etc.
			substitutions = {
				date = function()
					return os.date("%Y-%m-%d")
				end,
				time = function()
					return os.date("%H:%M")
				end,
			},
		},

		-- ─── Completion ────────────────────────────────────────────────────────
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},

		-- ─── Picker (Telescope) ────────────────────────────────────────────────
		picker = {
			name = "telescope",
			note_mappings = {
				-- In Telescope: create a new note from the current query
				new = "<C-x>",
				-- In Telescope: insert a wikilink to the selected note
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- In Telescope: tag the selected note
				tag_note = "<C-x>",
				-- In Telescope: insert a tag at cursor
				insert_tag = "<C-l>",
			},
		},

		-- ─── UI ────────────────────────────────────────────────────────────────
		ui = {
			enable = true,
			update_debounce = 200,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			hl_groups = {
				ObsidianTodo         = { bold = true, fg = "#f78c6c" },
				ObsidianDone         = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow   = { bold = true, fg = "#fc514e" },
				ObsidianTilde        = { bold = true, fg = "#ff5370" },
				ObsidianBullet       = { bold = true, fg = "#89ddff" },
				ObsidianRefText      = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon  = { fg = "#c792ea" },
				ObsidianTag          = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},

		-- ─── URL handling ──────────────────────────────────────────────────────
		-- Opens URLs with xdg-open (Linux) or open (macOS)
		follow_url_func = function(url)
			local opener
			if vim.fn.has("mac") == 1 then
				opener = "open"
			else
				opener = "xdg-open"
			end
			vim.fn.jobstart({ opener, url }, { detach = true })
		end,

		-- ─── Attachments ───────────────────────────────────────────────────────
		attachments = {
			-- Default folder for pasted images (used with img-clip.nvim)
			img_folder = "images",
			img_text_func = function(client, path)
				local rel_path = client:vault_relative_path(path)
				if rel_path then
					return string.format("![%s](%s)", path.name, rel_path)
				else
					return string.format("![%s](%s)", path.name, path)
				end
			end,
		},

		-- Suppress the "obsidian.nvim" header in the status line
		disable_frontmatter = false,

		-- ─── Note frontmatter ──────────────────────────────────────────────────
		-- Called when obsidian.nvim creates a new note — sets default frontmatter
		note_frontmatter_func = function(note)
			local out = {
				id = note.id,
				aliases = note.aliases,
				tags = note.tags,
				date = os.date("%Y-%m-%d"),
			}
			-- Merge any existing frontmatter fields so we don't clobber them
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end
			return out
		end,
	},

	-- ─── Keymaps ─────────────────────────────────────────────────────────────
	-- Defined here (outside opts) so they can reference vim.keymap.set directly.
	-- All bound with <leader>o prefix to avoid clashing with your other bindings.
	config = function(_, opts)
		require("obsidian").setup(opts)

		local map = function(key, cmd, desc)
			vim.keymap.set("n", key, cmd, { desc = "Obsidian: " .. desc, noremap = true, silent = true })
		end

		-- Navigation
		map("<leader>on", "<cmd>ObsidianNew<CR>",         "new note")
		map("<leader>os", "<cmd>ObsidianSearch<CR>",      "search vault")
		map("<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", "quick switch")
		map("<leader>ob", "<cmd>ObsidianBacklinks<CR>",   "backlinks")
		map("<leader>ol", "<cmd>ObsidianLinks<CR>",       "links in note")
		map("<leader>of", "<cmd>ObsidianFollowLink<CR>",  "follow link")
		map("<leader>oo", "<cmd>ObsidianOpen<CR>",        "open in Obsidian app")

		-- Daily notes
		map("<leader>od", "<cmd>ObsidianToday<CR>",       "today's daily note")
		map("<leader>oy", "<cmd>ObsidianYesterday<CR>",   "yesterday's note")
		map("<leader>om", "<cmd>ObsidianTomorrow<CR>",    "tomorrow's note")

		-- Templates & tags
		map("<leader>ot", "<cmd>ObsidianTemplate<CR>",    "insert template")
		map("<leader>oT", "<cmd>ObsidianTags<CR>",        "browse tags")

		-- Rename (updates all backlinks automatically)
		map("<leader>or", "<cmd>ObsidianRename<CR>",      "rename note")

		-- Paste image and insert markdown link
		-- Works alongside your existing img-clip.nvim setup
		map("<leader>oi", "<cmd>ObsidianPasteImg<CR>",    "paste image")
	end,
}
