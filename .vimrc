set encoding=utf-8
scriptencoding utf-8

"---------------------------------------------------
" Configration: NeoBundle設定 NeoBundle
"---------------------------------------------------
if has('vim_starting')
  " 初回起動時のみruntimepathにNeoBundleのパスを指定する
  set runtimepath+=~/.vim/bundle/neobundle.vim/

  " NeoBundleが未インストールであればgit cloneする
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install NeoBundle..."
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'
"----------------------------------------------------------
" ここに追加したいVimプラグインを記述
" 高機能ファイルエクスプローラー
NeoBundle 'scrooloose/nerdtree'
" ステータスライン装飾
NeoBundle 'bling/vim-airline'
" コメントアウトプラグイン
NeoBundle 'tomtom/tcomment_vim'
" ペースト時に自動インデント無効化
NeoBundle 'ConradIrwin/vim-bracketed-paste'
" HTML/CSS コーディング補助
NeoBundle 'mattn/emmet-vim'
" Railsプロジェクト補助
NeoBundle 'tpope/vim-rails'
" RubyのEndを自動入力
NeoBundle 'tpope/vim-endwise'
" 行末の半角スペース可視化
NeoBundle 'bronson/vim-trailing-whitespace'
" 閉じ括弧等の自動補完
NeoBundle "kana/vim-smartinput"
" インデントに色を付けて見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'
" lua機能が有効になっている場合
if has('lua')
" キーワード補完プラグイン
  NeoBundle 'Shougo/neocomplete.vim'
  " スニペット（定型構文入力補助）
  NeoBundle 'Shougo/neosnippet.vim'
  " スニペット定義ファイル
  NeoBundle 'Shougo/neosnippet-snippets'
endif
" カラースキームmolokai
NeoBundle 'tomasr/molokai'
"----------------------------------------------------------
call neobundle#end()

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 未インストールのVimプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
NeoBundleCheck


"---------------------------------------------------
" Configration: 基本設定 Basics
"---------------------------------------------------
" スクロール時の余白確保
set scrolloff=5
" 一行に長い文章を書いていても自動折り返しをしない
set textwidth=0
" 他で書き換えられたら自動で読み直す
set autoread
" 編集中でも他のファイルを開けるようにする
set hidden
" テキスト整形オプション、マルチバイト系を追加
set formatoptions=lmoq
" コマンドをステータス行に表示
set showcmd
" 現在のモードを表示
set showmode
" バックアップ取らない
set nobackup
" クリップボードへコピー
set clipboard=unnamedplus,autoselect
" バックスペースで特殊記号も削除可能に
set backspace=indent,eol,start
" CLモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" コマンドヒストリー履歴数の設定
set history=1000


"---------------------------------------------------
" Configration: マウスの有効化　Mouse
"---------------------------------------------------
" マウスでカーソル移動やスクロール移動が出来るようにする
if has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
   elseif v:version > 703 || v:version is 703 && has('patch632')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif


"---------------------------------------------------
" Configration: ペースト設定 Paste
"---------------------------------------------------
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


"---------------------------------------------------
" Configration: 文字コード設定 Encoding
"---------------------------------------------------
" 保存時の文字コード
set fileencoding=utf-8
" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac
" □や○文字が崩れる問題を解決
set ambiwidth=double


"---------------------------------------------------
" Configration: 表示設定 Apperance
"---------------------------------------------------
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" 入力中のコマンドを表示する
set showcmd
" 括弧の対応をハイライト
set showmatch
" 行番号表示
set number
" 文字位置情報表示
set ruler
" 印字不可能文字を16進数で表示
set display=uhex
" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast
" 横カーソルラインを表示
set cursorline
" 縦カーソルラインを表示
" set cursorcolumn
" 行番号の色
highlight LineNr ctermfg=darkgray
" コマンドモードの補完
set wildmenu


"---------------------------------------------------
" Configration: インデント設定 Indent
"---------------------------------------------------
" タブ入力時にスペースを入力する
set expandtab
" 自動でインデント
set autoindent
" 新しい行のインデントを現在行と同じ量にする
set smartindent
" Tabの表示幅
set tabstop=2
" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2
" インデント幅設定
set shiftwidth=2


"---------------------------------------------------
" Configration: 文字列検索 Search
"---------------------------------------------------
" インクリメンタルサーチ １文字入力毎に検索を行う
set incsearch
" 検索パターンに大文字小文字を区別しない
set ignorecase
" 検索パターンに大文字を含んでいたら大文字小文字を区別する
set smartcase
" 検索結果をハイライト
set hlsearch
" ESCキー2度押しでハイライトの切り替え
nnoremap <Esc><Esc> :<C-u>set nohlsearch!<CR>


"---------------------------------------------------
" Plugin: ステータスバー設定 vim-airline
"---------------------------------------------------
" description
let g:airline#extensions#tabline#enabled = 1
" description
set laststatus=2


"---------------------------------------------------
" Plugin: HTML/CSSコーディング補助 emmet-vim
"---------------------------------------------------
" ショートカット設定
let g:user_emmet_expandabbr_key = '<c-e>'
" lang設定をjaになるよう設定
let g:user_emmet_settings = {
\       'variables' : {
\       'lang' : 'ja'
\       }
\ }


"---------------------------------------------------
" Plugin: インデント確認補助 vim-indent-guides
"---------------------------------------------------
" 自動起動ON
let g:indent_guides_enable_on_vim_startup = 1
" 無効にしたいファイルタイプの追加
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
" 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" 奇数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626 ctermbg=gray
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=110
" 偶数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3c3c3c ctermbg=darkgray
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=140
" ハイライト色の変化の幅
let g:indent_guides_color_change_percent = 30


"---------------------------------------------------
" Plugin: キーワード保管＆スニペット neocomplete neosnippet neosnippet-snippets
"---------------------------------------------------
" 自動起動設定
let g:neocomplete#enable_at_startup = 1
if neobundle#is_installed('neocomplete.vim')
  " Vim起動時にneocompleteを有効にする
  let g:neocomplete#enable_at_startup = 1
  " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
  let g:neocomplete#enable_smart_case = 1
  " 3文字以上の単語に対して補完を有効にする
  let g:neocomplete#min_keyword_length = 3
  " 区切り文字まで補完する
  let g:neocomplete#enable_auto_delimiter = 1
  " 1文字目の入力から補完のポップアップを表示
  let g:neocomplete#auto_completion_start_length = 1
  " バックスペースで補完のポップアップを閉じる
  inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

  " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定
  " imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
  " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ
  " imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
	imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif


"---------------------------------------------------
" Plugin: カラースキーム molokai
"---------------------------------------------------
" molokaiがインストールされていればカラースキームにmolokaiを設定する
if neobundle#is_installed('molokai')
  colorscheme molokai
  hi Comment ctermfg=102
  hi Visual  ctermbg=236
endif
" シンタックスハイライト有効
syntax enable
" 既に256色環境なら無くても良い
set t_Co=256


"---------------------------------------------------
" Plugin: ファイルエクスプローラー NerdTree
"---------------------------------------------------
" :NERDTreeToggleのショートカットを定義
nnoremap <silent><C-n> :NERDTreeToggle<CR>
" 起動時にBookmarkを表示
let g:NERDTreeShowBookmarks=1
" 起動時にNerdTreeを表示
" autocmd vimenter * NERDTree
" ファイル名が指定されてVIMが起動した場合はNERDTreeを表示しない
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable  = '>'
let g:NERDTreeDirArrowCollapsible = '|'
