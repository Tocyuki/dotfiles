-- lua/user/ui.lua
-- colorscheme - VeryLazy時に適用（lazy.nvimでテーマ読み込み後）
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    if not pcall(function() vim.cmd.colorscheme("tokyonight-night") end) then
      vim.cmd.colorscheme("desert")
    end
  end,
})

-- 透明化設定
local function apply_transparent_bg()
  vim.o.winblend, vim.o.pumblend = 0, 10
  for _, name in ipairs({
    "Normal","NormalNC","SignColumn","FoldColumn","LineNr",
    "EndOfBuffer","StatusLineNC","TabLineFill","NormalFloat","FloatBorder","Pmenu",
  }) do
    vim.api.nvim_set_hl(0, name, { bg = "NONE" })
  end
end

vim.api.nvim_create_autocmd({ "VimEnter","ColorScheme" }, { callback = apply_transparent_bg })
apply_transparent_bg()

-- mini.indentscope のガイド色を薄いグレーに（plugins/editor.lua と連携）
local function set_indent_color()
  pcall(vim.api.nvim_set_hl, 0, "MiniIndentscopeSymbol", { fg = "#666666", nocombine = true })
end
set_indent_color()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_indent_color })

-- 補完ウィンドウのハイライトは snacks.lua で統一管理（TokyoNightテーマ準拠）
