"---------------------------------------------------
" Configration: NeoBundle設定 NeoBundle
"---------------------------------------------------
if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
   
call neobundle#begin(expand('~/.vim/bundle/'))
	NeoBundleFetch 'Shougo/neobundle.vim'

	NeoBundle 'Shougo/vimproc', {
		\ 'build' : {
			\ 'windows' : 'make -f make_mingw32.mak',
			\ 'cygwin' : 'make -f make_cygwin.mak',
			\ 'mac' : 'make -f make_mac.mak',
			\ 'unix' : 'make -f make_unix.mak',
		\ },
	\ }

	NeoBundle 'Shougo/neocomplcache'				" 入力補完機能を提供
	NeoBundle 'Shougo/neosnippet'					" スニペット挿入
	NeoBundle 'Shougo/neosnippet-snippets'			" スニペットの定義ファイル
	NeoBundle 'Shougo/vimshell'						" vimからシェルを起動
	NeoBundle 'Shougo/unite.vim'					" vimの統合管理インターフェース 
	NeoBundle 'Shougo/neomru.vim'					" unite.vimを利用するために必要
	NeoBundle 'scrooloose/nerdtree'					" vimを開きながらディレクトリをツリー表示
	NeoBundle 'scrooloose/syntastic'				" ファイルの構文エラーチェック
	NeoBundle 'bling/vim-airline'					" ステータスライン装飾
	NeoBundle 'tomtom/tcomment_vim'					" コメントアウトプラグイン
	NeoBundle 'tpope/vim-surround'					" 選択中のテキストを括弧 / 引用符 / HTMLタグで囲う
	NeoBundle 'tpope/vim-endwise'					" rubyの構文でendを自動入力
	NeoBundle 'Align'								" CSVやらTSVやらの整形に特化したプラグイン
	NeoBundle 'ConradIrwin/vim-bracketed-paste'		" ペースト時に自動インデント無効化

call neobundle#end()

NeoBundleFetch 'Shougo/neobundle.vim'   " Required: Let NeoBundle manage NeoBundle
NeoBundleCheck


"---------------------------------------------------
" Configration: 基本設定 Basics
"---------------------------------------------------
set scrolloff=5							" スクロール時の余白確保
set textwidth=0							" 一行に長い文章を書いていても自動折り返しをしない
set autoread							" 他で書き換えられたら自動で読み直す
set hidden								" 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq					" テキスト整形オプション、マルチバイト系を追加
set showcmd								" コマンドをステータス行に表示
set showmode							" 現在のモードを表示
set nobackup							" バックアップ取らない
set clipboard=unnamedplus,autoselect	" クリップボードへコピー
set backspace=indent,eol,start			" バックスペースで特殊記号も削除可能に


"---------------------------------------------------
" Configration: 表示設定 Apperance
"---------------------------------------------------
set showmatch							" 括弧の対応をハイライト
set number								" 行番号表示
set display=uhex						" 印字不可能文字を16進数で表示
set lazyredraw							" コマンド実行中は再描画しない
set ttyfast								" 高速ターミナル接続を行う
set cursorline							" カーソルラインを表示
set background=light					" 背景色の傾向(カラースキームがそれに併せて色の明暗を変えてくれる
syntax enable							" シンタックスハイライト有効


"---------------------------------------------------
" Configration: インデント設定 Indent
"---------------------------------------------------
set autoindent							" 自動でインデント
set smartindent							" 新しい行のインデントを現在行と同じ量にする
set tabstop=4							" Tabの表示幅
set shiftwidth=4						" インデント幅設定


"---------------------------------------------------
" Plugin: neocomplcache
"---------------------------------------------------
let g:acp_enableAtStartup = 0								" Disable AutoComplPop.
let g:neocomplcache_enable_at_startup = 1					" Use neocomplcache.
let g:neocomplcache_enable_smart_case = 1					" Use smartcase.
let g:neocomplcache_min_syntax_length = 3					" Set minimum syntax keyword length.
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
    \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


"---------------------------------------------------
" Plugin: neosnippet
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


"---------------------------------------------------
" Plugin: vim-airline
"---------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
set t_Co=256
set laststatus=2


"---------------------------------------------------
" Plugin: syntastic
"---------------------------------------------------
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 2


"---------------------------------------------------
" Plugin: tcomment_vim
"---------------------------------------------------
" Usage: gcc



