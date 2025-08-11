-- lua/user/keymaps.lua
local map = vim.keymap.set
map("n","<Leader>k", ":bd<CR>")
map("n","<Leader>w", ":w<CR>")
map("n","<Leader>r", ":%s;\\<<C-r><C-w>\\>;g<Left><Left>;")
map("n","<Esc><Esc>", ":set nohlsearch!<CR>")

-- terminal helpers
map("n",";lg", ":tab terminal lazygit<CR>")
map("n",";ld", ":tab terminal lazydocker<CR>")

-- window move/split
map("n","<C-h>", "<C-w>h"); map("n","<C-j>", "<C-w>j")
map("n","<C-k>", "<C-w>k"); map("n","<C-l>", "<C-w>l")
map("n","vs", ":vsplit<CR>"); map("n","ss", ":split<CR>")
