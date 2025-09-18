local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.conceallevel = 2
vim.diagnostic.config({
   update_in_insert = true,
})
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })  -- Normal mode
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true }) -- Insert mode
vim.wo.number = true
vim.wo.relativenumber = true
vim.api.nvim_set_keymap('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
vim.cmd([[highlight CursorLineNr guifg=#FF5F87]])
vim.wo.cursorline = true
vim.keymap.set("n", "<leader>yl", function()
    local line = vim.api.nvim_get_current_line()
    vim.fn.setreg("+", line) -- copy current line to system clipboard
    print("Copied to clipboard: " .. line)
end)

require("vim-options")

require("lazy").setup("plugins")
