-- lua/user/ui.lua

-- colorscheme
vim.cmd.colorscheme("desert")

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

-- nvim-cmp用のカスタムハイライトグループ
local function set_cmp_highlights()
  -- 補完ウィンドウ（背景は薄いグレー、文字は白）
  vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#2a2a2a", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "CmpBorder", { bg = "#2a2a2a", fg = "#555555" })
  vim.api.nvim_set_hl(0, "CmpSel", { bg = "#3a3a3a", fg = "#ffffff", bold = true })

  -- ドキュメントウィンドウ（もう少し薄い色）
  vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#1e1e1e", fg = "#cccccc" })
  vim.api.nvim_set_hl(0, "CmpDocBorder", { bg = "#1e1e1e", fg = "#444444" })
end
set_cmp_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_cmp_highlights })
