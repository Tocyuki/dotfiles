-- lua/user/options.lua
vim.o.helplang = "ja"
vim.o.termguicolors = true
vim.o.background = "dark"

vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencodings = "ucs-boms,utf-8,euc-jp,cp932"
vim.o.fileformats  = "unix,dos,mac"
vim.o.ambiwidth    = "single"

vim.opt.clipboard:append("unnamed")
vim.opt.signcolumn = "yes"
vim.o.updatetime   = 300
vim.o.mouse        = "a"
vim.o.scrolloff    = 5
vim.o.autoread     = true
vim.o.hidden       = true
vim.o.formatoptions= "lmoq"

vim.o.number       = true
vim.o.cursorline   = true
vim.o.splitbelow   = true
vim.o.splitright   = true
vim.o.laststatus   = 2
vim.o.showtabline  = 2

vim.o.expandtab    = true
vim.o.autoindent   = true
vim.o.smartindent  = true
vim.o.tabstop      = 2
vim.o.softtabstop  = 2
vim.o.shiftwidth   = 2

vim.o.incsearch    = true
vim.o.ignorecase   = true
vim.o.smartcase    = true
vim.o.hlsearch     = true

vim.o.shell        = "/bin/zsh"
vim.o.shellcmdflag = "-lc"

-- パフォーマンス最適化
vim.o.timeoutlen   = 300      -- マッピングシーケンスのタイムアウト（デフォルト1000ms）
vim.o.ttimeoutlen  = 10       -- キーコードのタイムアウト（Escの反応速度向上）
vim.o.lazyredraw   = true     -- マクロ・コマンド実行中の再描画を抑制
vim.o.synmaxcol    = 300      -- 長い行のシンタックス解析を制限（300文字まで）
vim.o.redrawtime   = 1500     -- 再描画のタイムアウト（デフォルト2000ms）

