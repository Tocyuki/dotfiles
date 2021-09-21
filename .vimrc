" ==============================
" Configration: vim-plug
" ==============================
" vim-plugがインストールされてなかったら自動でインストールする
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'simeji/winresizer'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tomtom/tcomment_vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'dag/vim-fish'
  Plug 'cespare/vim-toml'
  Plug 'tpope/vim-surround'
  Plug 'markonm/traces.vim'
  Plug 'vim-jp/vimdoc-ja'
  Plug 'easymotion/vim-easymotion'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'mattn/emmet-vim'
  Plug 'tpope/vim-endwise'
  Plug 'elzr/vim-json'
  Plug 'tpope/vim-fugitive'
  Plug 'hashivim/vim-terraform'
  Plug 'ryanoasis/vim-devicons'
  Plug 'overcache/NeoSolarized'
call plug#end()

let mapleader = "\<Space>"
set helplang=ja

" ==============================
" Plugin: vim-terraform
" ==============================
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
let g:terraform_binary_path = "/usr/local/bin/terraform"

" ==============================
" Plugin: fzf
" ==============================
" buffer list
nnoremap <Leader>b :Buffers<CR>
" vim command history
nnoremap <Leader>C :Commands<CR>
" git commits info
nnoremap <Leader>c :Commits<CR>
" opened file history
nnoremap <Leader>h :History<CR>
" vim command history
nnoremap <Leader>H :History:<CR>
" ls -a result
nnoremap <Leader>f :Files<CR>
" git ls-files result
nnoremap <Leader>g :GFiles<CR>
" git status result
nnoremap <Leader>s :GFiles?<CR>
" line in loaded buffer
nnoremap <Leader>l :Lines<CR>
" ag search result
nnoremap <Leader>a :Ag<CR>

" ==============================
" Plugin: Vim Airline
" ==============================
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized_flood'
nmap <C-n> <Plug>AirlineSelectNextTab
nmap <C-p> <Plug>AirlineSelectPrevTab

" ==============================
" Plugin: vim-json
" ==============================
let g:vim_json_syntax_conceal = 0

" ==============================
" Plugin: emmet-vim
" ==============================
" ショートカット設定
let g:user_emmet_expandabbr_key = '<c-e>'
" lang設定をjaになるよう設定
let g:user_emmet_settings = {'variables': {'lang' : 'ja'}}

" ==============================
" Plugin: fugitive
" ==============================
nmap <C-g> [fugitive]
" git checkout [FILE_NAME]
nnoremap <silent> [fugitive]r :Gread<CR>
" git blame
nnoremap <silent> [fugitive]b :Gblame<CR>

" ==============================
" Plugin: coc-vim
" ==============================
nmap <silent> cd <Plug>(coc-definition)
nmap <silent> cy <Plug>(coc-type-definition)
nmap <silent> ci <Plug>(coc-implementation)
nmap <silent> cr <Plug>(coc-references)
nmap <silent> <Space><Space> :<C-u>CocList<cr>
let g:coc_global_extensions = [
  \  'coc-yank'
  \, 'coc-json'
  \, 'coc-yaml'
  \, 'coc-toml'
  \, 'coc-markdownlint'
  \, 'coc-cfn-lint'
  \, 'coc-stylelintplus'
  \, 'coc-spell-checker'
  \, 'coc-fzf-preview'
  \, 'coc-tsserver'
  \, 'coc-eslint'
  \, 'coc-snippets'
  \, 'coc-prettier'
  \, 'coc-pairs'
  \, 'coc-fzf-preview'
  \, 'coc-explorer'
  \, 'coc-rust-analyzer'
  \, 'coc-html'
  \, 'coc-phpls'
  \, 'coc-solargraph'
  \, 'coc-python'
  \, 'coc-sh'
  \, 'coc-vimlsp'
  \, 'coc-sql'
  \, 'coc-go'
  \, ]
nnoremap <silent> <Leader>y  :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" ==============================
" Plugin: coc-explorer
" ==============================
nnoremap <Leader>e :CocCommand explorer<CR>

" ==============================
" Plugin: vim-easymotion
" ==============================
" 任意の2文字から始まる文字列の先頭にジャンプ
map <Leader>m <Plug>(easymotion-bd-f2)
" ウィンドウを飛び越えて移動
nmap <Leader>m <Plug>(easymotion-overwin-f2)

" ==============================
" Configration: Encoding Charactor
" ==============================
scriptencoding utf-8                          " スクリプトファイルの文字コードをUTF-8に設定
set encoding=utf-8                            " 文字コードをUTF-8に設定
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac                  " 改行コードの自動判別. 左側が優先される
set ambiwidth=single                          " lazygitを開いた時に表示が崩れる問題の対応
" set ambiwidth=double                          " □や○文字が崩れる問題を解決

" ==============================
" Configration: Basics
" ==============================
autocmd BufWritePre * :%s/\s\+$//ge   " 行末の余分なスペースを自動で削除する
filetype plugin indent on             " ファイルタイプ別のVimプラグイン/インデントを有効にする
if &compatible
  set nocompatible
endif
set noswapfile                 " swapファイルを作成しない
set scrolloff=5                " スクロール時の余白確保
set textwidth=0                " 一行に長い文章を書いていても自動折り返しをしない
set autoread                   " 他で書き換えられたら自動で読み直す
set hidden                     " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq         " テキスト整形オプション、マルチバイト系を追加
set showcmd                    " コマンドをステータス行に表示
set showmode                   " 現在のモードを表示
set nobackup                   " バックアップ取らない
set nowritebackup              "
set backspace=indent,eol,start " バックスペースで特殊記号も削除可能に
set wildmenu                   " CLモードで<Tab>キーによるファイル名補完を有効にする
set history=10000              " コマンドヒストリー履歴数の設定
set splitright                 " 画面を縦分割する際に右に開く
set mouse=a                    " マウス操作を可能にする
set virtualedit=block          " 矩形選択でテキストがないところを選択できるようにする
set helplang=ja                " ヘルプの表示を日本語優先にする
set autowrite                  " 他のバッファに移動する際に自動保存する
set shell=fish                 " Default shellをfishにする

" ==============================
" Configration: Apperance
" ==============================
syntax on
colorscheme NeoSolarized
set termguicolors     " Requirements for NeoSolarized
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
set splitbelow        " Terminalを下に開く
set laststatus=2      " ステータスラインを表示
set showtabline=2     " タブを常に表示
set t_Co=256

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

" ==============================
" Configration: Clipboard
" ==============================
set clipboard+=unnamed    " クリップボードへコピー
set clipboard+=autoselect
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

" ==============================
" Configration: Undo
" ==============================
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  if !isdirectory(undo_path)
    call mkdir(undo_path, 'p')
  endif
  let &undodir = undo_path
  set undofile
endif

" ==============================
" Configration: Keymap
" ==============================
" kill buffer
nnoremap <Leader>k :bd<CR>
" 保存
nnoremap <Leader>w :w<CR>
" カーソル下の単語を置換後の文字を入力するだけの状態にする
nnoremap <Leader>r :%s;\<<C-R><C-W>\>;g<Left><Left>;
" ESCキー2度押しでハイライトの切り替え
nnoremap <Esc><Esc> :set nohlsearch!<CR>
" Lazygitの起動
nnoremap ;lg :tab term ++close lazygit<CR>
" Lazydockerの起動
nnoremap ;ld :tab term ++close lazydocker<CR>
" スペース + t でTerminalを開く
nnoremap <Leader>t :term ++close ++rows=20<CR>
" Vimのキーバインドでウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" 画面縦分割
nnoremap vs :<C-u>vsplit<CR>
" 画面横分割
nnoremap ss :<C-u>split<CR>

