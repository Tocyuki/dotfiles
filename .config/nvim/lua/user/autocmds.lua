-- lua/user/autocmds.lua

-- 行末スペース削除
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Terminal は自動で insert
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() vim.cmd("startinsert") end,
})

