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
	" キーワード補完プラグイン
	NeoBundle 'Shougo/neocomplete.vim'
	" PHP関数説明補助
	NeoBundle 'violetyk/neocomplete-php.vim'
	" スニペット（定型構文入力補助）
	NeoBundle 'Shougo/neosnippet'
	" スニペット定義ファイル
	NeoBundle 'Shougo/neosnippet-snippets'

call neobundle#end()

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
" カーソルラインを表示
set cursorline
" 行番号の色
highlight LineNr ctermfg=darkgray
" シンタックスハイライト有効
syntax enable

colorscheme torte


"---------------------------------------------------
" Configration: インデント設定 Indent
"---------------------------------------------------
" 自動でインデント
set autoindent
" 新しい行のインデントを現在行と同じ量にする
set smartindent
" Tabの表示幅
set tabstop=2
" インデント幅設定
set shiftwidth=2


"---------------------------------------------------
" Plugin: ステータスバー設定 vim-airline
"---------------------------------------------------
" description
let g:airline#extensions#tabline#enabled = 1
" description
set t_Co=256
" description
set laststatus=2


"---------------------------------------------------
" Plugin: HTML/CSSコーディング補助 emmet-vim
"---------------------------------------------------
" ショートカット設定
let g:user_emmet_expandabbr_key = '<c-e>'
" lang設定をjaになるよう設定
let g:user_emmet_settings = {
\	'variables' : {
\   	'lang' : 'ja'
\	}
\ }


"---------------------------------------------------
" Plugin: インデント確認補助 vim-indent-guides
"---------------------------------------------------
" 自動起動ON
let g:indent_guides_enable_on_vim_startup = 1

let g:indent_guides_auto_colors=0

autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=110

autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=140


"---------------------------------------------------
" Plugin: PHP関数説明補助 neocomplete-php.vim
"---------------------------------------------------
" 日本語説明表示設定
let g:neocomplete_php_locale = 'ja'


"---------------------------------------------------
" Plugin: キーワード補完 neocomplete
"---------------------------------------------------
" 自動起動設定
let g:neocomplete#enable_at_startup = 1


"---------------------------------------------------
" Plugin: スニペット neosnippet neosnippet-snippets
"---------------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
