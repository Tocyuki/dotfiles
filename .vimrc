"---------------------------------------------------
" Configration: NeoBundle設定 NeoBundle
"---------------------------------------------------
if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
	NeoBundleFetch 'Shougo/neobundle.vim'
	
	" NeoBundle 'Shougo/vimproc', {
	" \	'build' : {
	" \		'windows' : 'make -f make_mingw32.mak',
	" \		'cygwin' : 'make -f make_cygwin.mak',
	" \		'mac' : 'make -f make_mac.mak',
	" \		'unix' : 'make -f make_unix.mak'
	" \	},
	" \}

	NeoBundle 'bling/vim-airline'									" ステータスライン装飾
	NeoBundle 'tomtom/tcomment_vim'								" コメントアウトプラグイン
	NeoBundle 'ConradIrwin/vim-bracketed-paste'		" ペースト時に自動インデント無効化
	NeoBundle 'mattn/emmet-vim'										" HTML/CSS コーディング補助
	NeoBundle 'tpope/vim-rails'										" Railsプロジェクト補助
	NeoBundle 'tpope/vim-endwise'									" RubyのEndを自動入力
	NeoBundle 'bronson/vim-trailing-whitespace'		" 行末の半角スペース可視化
	NeoBundle "kana/vim-smartinput"								" 閉じ括弧等の自動補完
	NeoBundle 'nathanaelkane/vim-indent-guides'		" インデントに色を付けて見やすくする

call neobundle#end()

NeoBundleCheck

"---------------------------------------------------
" Configration: 基本設定 Basics
"---------------------------------------------------
set scrolloff=5																	" スクロール時の余白確保
set textwidth=0																	" 一行に長い文章を書いていても自動折り返しをしない
set autoread																		" 他で書き換えられたら自動で読み直す
set hidden																			" 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq													" テキスト整形オプション、マルチバイト系を追加
set showcmd																			" コマンドをステータス行に表示
set showmode																		" 現在のモードを表示
set nobackup																		" バックアップ取らない
set clipboard=unnamedplus,autoselect						" クリップボードへコピー
set backspace=indent,eol,start									" バックスペースで特殊記号も削除可能に
set wildmenu																		" CLモードで<Tab>キーによるファイル名補完を有効にする


"---------------------------------------------------
" Configration: 表示設定 Apperance
"---------------------------------------------------
set title																				" ウインドウのタイトルバーにファイルのパス情報等を表示する"
set showcmd																			" 入力中のコマンドを表示する
set showmatch																		" 括弧の対応をハイライト
set number																			" 行番号表示
set ruler																				" 文字位置情報表示
set display=uhex																" 印字不可能文字を16進数で表示
set lazyredraw																	" コマンド実行中は再描画しない
set ttyfast																			" 高速ターミナル接続を行う
set cursorline																	" カーソルラインを表示
highlight LineNr ctermfg=darkgray								" 行番号の色
syntax enable																		" シンタックスハイライト有効


"---------------------------------------------------
" Configration: インデント設定 Indent
"---------------------------------------------------
set autoindent																	" 自動でインデント
set smartindent																	" 新しい行のインデントを現在行と同じ量にする
set tabstop=2																		" Tabの表示幅
set shiftwidth=2																" インデント幅設定


"---------------------------------------------------
" Plugin: ステータスバー設定 vim-airline
"---------------------------------------------------
let g:airline#extensions#tabline#enabled = 1		" description
set t_Co=256																		" description
set laststatus=2																" description


"---------------------------------------------------
" Plugin: HTML/CSSコーディング補助 emmet-vim
"---------------------------------------------------
let g:user_emmet_expandabbr_key = '<c-e>'				" ショートカット設定
let g:user_emmet_settings = {
\	'variables' : {
\   	'lang' : 'ja'
\	}
\ }


"---------------------------------------------------
" Plugin: インデント確認補助 vim-indent-guides
"---------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1	" 自動起動ON
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=110
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=140
