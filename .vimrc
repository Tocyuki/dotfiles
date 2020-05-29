" ==============================
" Configration: dein.vim
" ==============================
if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/dein/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/dein/dein_lazy.toml', {'lazy': 1})
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

" ==============================
" Configration: Encoding Charactor
" ==============================
set encoding=utf-8                            " 文字コードをUTF-8に設定
scriptencoding utf-8                          " スクリプトファイルの文字コードをUTF-8に設定
set fileencoding=utf-8                        " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac                  " 改行コードの自動判別. 左側が優先される
set ambiwidth=double                          " □や○文字が崩れる問題を解決

" ==============================
" Configration: Basics
" ==============================
set noswapfile                        " swapファイルを作成しない
set scrolloff=5                       " スクロール時の余白確保
set textwidth=0                       " 一行に長い文章を書いていても自動折り返しをしない
set autoread                          " 他で書き換えられたら自動で読み直す
set hidden                            " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq                " テキスト整形オプション、マルチバイト系を追加
set showcmd                           " コマンドをステータス行に表示
set showmode                          " 現在のモードを表示
set nobackup                          " バックアップ取らない
set backspace=indent,eol,start        " バックスペースで特殊記号も削除可能に
set wildmenu                          " CLモードで<Tab>キーによるファイル名補完を有効にする
set history=10000                     " コマンドヒストリー履歴数の設定
set splitright                        " 画面を縦分割する際に右に開く
set mouse=a                           " マウス操作を可能にする
autocmd BufWritePre * :%s/\s\+$//ge   " 行末の余分なスペースを自動で削除する
filetype plugin indent on             " ファイルタイプ別のVimプラグイン/インデントを有効にする

" ==============================
" Configration: Apperance
" ==============================
syntax enable         " シンタックスハイライトを有効にする
set title             " ウインドウのタイトルバーにファイルのパス情報等を表示する
set showcmd           " 入力中のコマンドを表示する
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set ruler             " 文字位置情報表示
set display=uhex      " 印字不可能文字を16進数で表示
set lazyredraw        " コマンド実行中は再描画しない
set ttyfast           " 高速ターミナル接続を行う
set cursorcolumn      " 横カーソルラインを表示
set cursorline        " 横カーソルラインを表示
set wildmenu          " コマンドモードの補完
" アンダーラインを引く(color terminal)
autocmd ColorScheme * highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" ==============================
" Configration: Indent
" ==============================
set expandtab     " タブ入力時にスペースを入力する
set autoindent    " 自動でインデント
set smartindent   " 新しい行のインデントを現在行と同じ量にする
set tabstop=2     " Tabの表示幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set shiftwidth=2  " インデント幅設定

" ==============================
" Configration: Searching
" ==============================
set incsearch   " インクリメンタルサーチ １文字入力毎に検索を行う
set ignorecase  " 検索パターンに大文字小文字を区別しない
set smartcase   " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch    " 検索結果をハイライト
" ESCキー2度押しでハイライトの切り替え
nnoremap <Esc><Esc> :<C-u>set nohlsearch!<CR>

" ==============================
" Configration: Window Operation Shortcut
" ==============================
" Vimのキーバインドでウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" 画面縦分割
nnoremap vs :<C-u>vsplit<CR>
nnoremap ss :<C-u>split<CR>
" タブ操作
nnoremap <silent> tf :<C-u>tabfirst<CR>
nnoremap <silent> tl :<C-u>tablast<CR>
nnoremap <silent> tn :<C-u>tabnext<CR>
nnoremap <silent> tN :<C-u>tabNext<CR>
nnoremap <silent> tp :<C-u>tabprevious<CR>
nnoremap <silent> te :<C-u>tabedit<CR>
nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> to :<C-u>tabonly<CR>
nnoremap <silent> ts :<C-u>tabs<CR>
" バッファ操作
nnoremap <silent> bn :<C-u>bnext<CR>
nnoremap <silent> bp :<C-u>bprev<CR>
nnoremap <silent> bf :<C-u>bfirst<CR>
nnoremap <silent> bl :<C-u>blast<CR>

" ==============================
" Configration: Clipboard
" ==============================
set clipboard+=unnamed                " クリップボードへコピー
set clipboard+=autoselect             "
" クリップボードからペーストする時だけインデントしないようにする
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

