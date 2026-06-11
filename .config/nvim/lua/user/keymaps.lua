-- lua/user/keymaps.lua
local map = vim.keymap.set
local utils = require("user.utils")

map("n", "<leader>bd", "<Cmd>Bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<Cmd>%bd|e#|bd#<CR>", { desc = "Delete other buffers" })
map("n", "<Leader>K", "<Cmd>%bd|e#|bd#<CR>", { desc = "Delete other buffers" })
map("n", "<C-s>", "<Cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
map("n", "<Leader>r", ":%s;\\<<C-r><C-w>\\>;g<Left><Left>;", { desc = "Replace word under cursor" })
map("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map('t', '<Leader>;f', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', false)
  vim.schedule(function()
    vim.cmd('wincmd p')
  end)
end, { noremap = true })

-- terminal helpers
map("n",";ld", utils.create_terminal_with_autocmd("lazydocker"))

-- diagnostics navigation
map("n", "]e", function() vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.ERROR}) end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.jump({count = -1, severity = vim.diagnostic.severity.ERROR}) end, { desc = "Previous error" })
map("n", "]w", function() vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.WARN}) end, { desc = "Next warning" })
map("n", "[w", function() vim.diagnostic.jump({count = -1, severity = vim.diagnostic.severity.WARN}) end, { desc = "Previous warning" })

-- window move/split
map("n","<C-h>", "<C-w>h", { desc = "Move to left window" }); map("n","<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n","<C-k>", "<C-w>k", { desc = "Move to upper window" }); map("n","<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n","vs", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n","ss", "<Cmd>split<CR>", { desc = "Split window horizontally" })
