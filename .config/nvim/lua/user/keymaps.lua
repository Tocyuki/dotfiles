-- lua/user/keymaps.lua
local map = vim.keymap.set
map("n","<Leader>k", ":bd<CR>")
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
map("n",";lg", function()
  vim.cmd("tab terminal lazygit")
  -- ターミナル終了時に自動でタブを閉じる
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    once = true,
    callback = function()
      vim.cmd("bd!")
    end
  })
end)
map("n",";ld", function()
  vim.cmd("tab terminal lazydocker")
  -- ターミナル終了時に自動でタブを閉じる
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    once = true,
    callback = function()
      vim.cmd("bd!")
    end
  })
end)

-- window move/split
map("n","<C-h>", "<C-w>h"); map("n","<C-j>", "<C-w>j")
map("n","<C-k>", "<C-w>k"); map("n","<C-l>", "<C-w>l")
map("n","vs", ":vsplit<CR>"); map("n","ss", ":split<CR>")
