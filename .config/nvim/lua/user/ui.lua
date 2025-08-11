-- lua/user/ui.lua

-- colorscheme
vim.cmd.colorscheme("desert")

-- desert 背景に合わせて主要BGを統一（透明化/フロート不統一の対策）
local function apply_bg_from_normal()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local bg = hl.bg or 0x000000
  vim.o.winblend, vim.o.pumblend = 0, 0
  for _, name in ipairs({
    "Normal","NormalNC","SignColumn","FoldColumn","LineNr",
    "EndOfBuffer","StatusLineNC","TabLineFill","NormalFloat","FloatBorder","Pmenu",
  }) do
    vim.api.nvim_set_hl(0, name, { bg = bg })
  end
end

vim.api.nvim_create_autocmd({ "VimEnter","ColorScheme" }, { callback = apply_bg_from_normal })
apply_bg_from_normal()

-- mini.indentscope のガイド色を薄いグレーに（plugins/editor.lua と連携）
local function set_indent_color()
  pcall(vim.api.nvim_set_hl, 0, "MiniIndentscopeSymbol", { fg = "#666666", nocombine = true })
end
set_indent_color()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_indent_color })
