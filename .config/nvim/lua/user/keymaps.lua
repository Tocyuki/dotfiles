-- lua/user/keymaps.lua
local map = vim.keymap.set
local utils = require("user.utils")

map("n","<Leader>k", ":bd<CR>")
map("n","<Leader>K", ":%bd|e#|bd#<CR>")
map("n","<Leader>w", ":w<CR>")
map("n","<Leader>r", ":%s;\\<<C-r><C-w>\\>;g<Left><Left>;")
map("n","<Esc><Esc>", ":set nohlsearch!<CR>")
map('t', '<Leader>;f', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', false)
  vim.schedule(function()
    vim.cmd('wincmd p')
  end)
end, { noremap = true })

-- terminal helpers
map("n",";lg", utils.create_terminal_with_autocmd("lazygit"))
map("n",";ld", utils.create_terminal_with_autocmd("lazydocker"))

-- window move/split
map("n","<C-h>", "<C-w>h"); map("n","<C-j>", "<C-w>j")
map("n","<C-k>", "<C-w>k"); map("n","<C-l>", "<C-w>l")
map("n","vs", ":vsplit<CR>"); map("n","ss", ":split<CR>")
