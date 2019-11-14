if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.vim/dein/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/dein/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

set number              "行番号を表示
set autoindent          "改行時に自動でインデントする
set tabstop=2           "タブを何文字の空白に変換するか
set shiftwidth=2        "自動インデント時に入力する空白の数
set expandtab           "タブ入力を空白に変換
set splitright          "画面を縦分割する際に右に開く
set clipboard=unnamed   "yank した文字列をクリップボードにコピー
set hls                 "検索した文字をハイライトする
"ウィンドウ間移動ショートカット
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" ウィンドウ分割ショートカット
nnoremap vs :<C-u>vsplit<CR>
nnoremap ss :<C-u>split<CR>
" Terminal-Jobモードキーマップ
tnoremap <Esc> <C-\><C-n>
