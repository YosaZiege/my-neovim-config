-- vim-options.lua
-- Fixed: shiftwidth was 3, mismatching tabstop=2. Now both are 2.
-- Added: persistent undo, better search defaults, split behaviour.

vim.g.mapleader = " "

-- ─── Indentation ─────────────────────────────────────────────────────────────
vim.opt.expandtab   = true  -- spaces instead of tabs
vim.opt.tabstop     = 2     -- a tab displays as 2 spaces
vim.opt.softtabstop = 2     -- <Tab> in insert mode inserts 2 spaces
vim.opt.shiftwidth  = 2     -- >> and auto-indent use 2 spaces (was 3 — fixed)
vim.opt.smartindent = true

-- ─── Persistent undo (survives buffer close and Neovim restart) ──────────────
vim.opt.undofile = true
vim.opt.undodir  = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p") -- create dir if missing

-- ─── Search ──────────────────────────────────────────────────────────────────
vim.opt.ignorecase = true  -- case-insensitive search ...
vim.opt.smartcase  = true  -- ... unless the query has uppercase

-- ─── Splits ──────────────────────────────────────────────────────────────────
vim.opt.splitright = true  -- vertical splits open to the right
vim.opt.splitbelow = true  -- horizontal splits open below

-- ─── Misc ────────────────────────────────────────────────────────────────────
vim.opt.scrolloff    = 8      -- keep 8 lines visible above/below cursor
vim.opt.signcolumn   = "yes"  -- always show the sign column (stops layout jumping)
vim.opt.updatetime   = 250    -- faster CursorHold (used by gitsigns, LSP hover)
vim.opt.termguicolors = true
