-- init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- ユーザ設定の読み込み
pcall(function() vim.loader.enable() end)
package.path = table.concat({
  vim.fn.stdpath('config') .. "/lua/?.lua",
  vim.fn.stdpath('config') .. "/lua/?/init.lua",
  package.path,
}, ";")
require("user.options")
require("user.keymaps")
require("user.autocmds")
require("user.ui")

-- プラグイン読み込み（lua/plugins/*.lua を自動で読む）
require("lazy").setup({ import = "plugins" })

