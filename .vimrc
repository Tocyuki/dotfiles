set t_ut=
set t_Co=256

"-------------------------------------------------------------------------------
" Plugin: NeoBundle
" memo: Excellent Plugin Manager
" refer:
"   * NeoBundleのインストール - Qiita
"     http://qiita.com/Kuchitama/items/68b6b5d5ed40f6f96310
" usage:
"   # Linux or Mac OS X
"   $ ln -s ~/dotfiles/vim ~/.vim
"   $ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
"
"   # Windows
"   $ mklink .vimrc \app\dotfiles\vimrc
"   $ mklink .gvimrc \app\dotfiles\gvimrc
"   $ mklink /d .vim \app\dotfiles\vim
"   $ git clone http://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
"
" Usage - auto-ctags
"   1. install ctags
"        mac    `brew install ctags`
"        debian `apt-get install exuberant-ctags`
"   2. run ctags
"        :Ctags
"
" http://www.daisaru11.jp/blog/2011/09/vimsyntastic%E3%81%A7%E6%96%87%E6%B3%95%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF%E3%82%92%E8%87%AA%E5%8B%95%E3%81%A7%E8%A1%8C%E3%81%86/
" http://soramugi.hateblo.jp/entry/2013/12/01/150433
"
" Usage - ag (faster grep)
"   1. install ag
"        mac    `brew install the_silver_searcher`
" http://blog.monochromegane.com/blog/2013/09/18/ag-and-unite/
"
"-------------------------------------------------------------------------------
if has('vim_starting')
  set nocompatible  " Be iMproved

  " Required
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required old ver.
" call neobundle#rc(expand('~/.vim/bundle/'))

" Required new ver.
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

  NeoBundle 'Shougo/neocomplcache'
  NeoBundle 'Shougo/neosnippet'
  NeoBundle 'Shougo/neosnippet-snippets'
  NeoBundle 'Shougo/vimshell'
  NeoBundle 'Shougo/unite.vim'
  NeoBundle 'Shougo/neomru.vim' "Unite::file_mruで使用
  NeoBundle 'scrooloose/nerdtree'
  NeoBundle 'scrooloose/syntastic'
  NeoBundle 'bling/vim-airline'
  NeoBundle 'vim-scripts/AnsiEsc.vim'
  NeoBundle 'soramugi/auto-ctags.vim'
  NeoBundle 'vim-scripts/taglist.vim'
  NeoBundle 'kannokanno/previm'
  NeoBundle 'tyru/open-browser.vim'
  NeoBundle 'zeekay/vice-colorful'
  NeoBundle 'AndrewRadev/switch.vim'
  NeoBundle 'AndrewRadev/splitjoin.vim'
  NeoBundle 'tomtom/tcomment_vim'
  NeoBundle 'tpope/vim-surround'
  NeoBundle 'tpope/vim-endwise'
  NeoBundle 'Align'
  NeoBundle 'h1mesuke/vim-alignta'
  NeoBundle 'SQLUtilities'
  NeoBundle 'vim-ruby/vim-ruby'
  NeoBundle 'tpope/vim-rails'
  NeoBundle 'basyura/unite-rails'
  NeoBundle 'thinca/vim-ft-svn_diff'      "svn commit時に差分を表示するプラグイン

  " Shougo Bundles here:
  "NeoBundle 'tpope/vim-fugitive'
  "NeoBundle 'kien/ctrlp.vim'
  "NeoBundle 'flazz/vim-colorschemes'
call neobundle#end()

NeoBundleFetch 'Shougo/neobundle.vim'   " Required: Let NeoBundle manage NeoBundle

NeoBundleCheck


"-------------------------------------------------------------------------------
" Plugin: NeoComplcache - 入力補完
"-------------------------------------------------------------------------------

"Note => This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


"-------------------------------------------------------------------------------
" Plugin: NeoSnippet - スニペット補完
"-------------------------------------------------------------------------------

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

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'


"-------------------------------------------------------------------------------
" Plugin: VimShell - Vim上でShellを実行する ( :VimShell )
"-------------------------------------------------------------------------------

nnoremap <silent> vs :VimShell<CR>
nnoremap <silent> vsc :VimShellCreate<CR>
nnoremap <silent> vp :VimShellPop<CR>


"-------------------------------------------------------------------------------
" Plugin: Unite - 高機能ファイラー
"-------------------------------------------------------------------------------

let mapleader = ","

nnoremap [unite] <Nop>
nmap <Leader> [unite]
" nmap <Leader>f [unite]

nnoremap [unite]u :<C-u>Unite -no-split<Space>
nnoremap <silent> ;  :<C-u>Unite history/command command<CR>
nnoremap <silent> [unite]a  :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]l  :<C-u>Unite file<CR>
nnoremap <silent> [unite]f  :<C-u>Unite file_rec -no-split<CR>
nnoremap <silent> [unite]r  :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> [unite]y  :<C-u>Unite history/yank<CR>
" nnoremap <silent> [unite]rm  :<C-u>Unite ref/man<CR>
" nnoremap <silent> [unite]re  :<C-u>Unite ref/mrlang<CR>
" nnoremap <silent> [unite]rr  :<C-u>Unite ref/refe<CR>
nnoremap <silent> [unite]B  :<C-u>Unite buffer_tab<CR>
nnoremap <silent> [unite]b  :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m  :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]j  :<C-u>Unite mark<CR>
nnoremap <silent> [unite]o  :<C-u>Unite outline:!<CR>
nnoremap <silent> [unite]p  :<C-u>Unite outline -auto-preview<CR>
nnoremap <silent> [unite]g  :<C-u>Unite grep: -buffer-name=search-buffer<CR>
nnoremap <silent> [unite]R  :<C-u>UniteResume search-buffer<CR>
nnoremap <silent> [unite]t  :<C-u>UniteWithCursorWord -buffer-name=tag tag<CR>
nnoremap <silent> [unite]h  :<C-u>Unite help<CR>
nnoremap <silent> [unite]t  :<C-u>Unite tag<CR>
nnoremap <silent> [unite]s  :<C-u>Unite snippet<CR>

let g:unite_enable_start_insert = 1		"insert modeで開始
let g:unite_source_file_mru_limit = 200	" MRU (Most Recently Used)の表示件数

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

function! s:unite_my_settings()
  " Overwrite settings.
  "inoremap <buffer> jj      <Plug>(unite_insert_leave)
  "nnoremap <silent><buffer> <C-k> :<C-u>call unite#mappings#do_action('preview')<CR>
  "inoremap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  "
endfunction
autocmd FileType unite call s:unite_my_settings()


"-------------------------------------------------------------------------------
" Plugin: NERDTree      - ファイルツリー ( :NERDTree )
" Plugin: Syntastic     - SyntaxCheck汎用プラグイン
" Plugin: AirLine       - Extend statusline
" Plugin: AnsiEsc       - ASCI文字を反映
" Plugin: auto-ctags    - ctagsを保存時に実行する
" Plugin: taglist.vim   - class, method tree list
" Plugin: previm        - previewer Markdown, textfile
" Plugin: open-browser  - Open browser
" Plugin: colorschema
"-------------------------------------------------------------------------------

colorscheme molokai-dark

let g:NERDTreeShowBookmarks=1		"起動時にBookmarkを表示
nnoremap <silent> tr :NERDTree<CR>

" ファイル指定で開かれた場合はNERDTreeは表示しない
"if !argc()
"    autocmd vimenter * NERDTree|normal gg3j
"endif

let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 2

let g:airline#extensions#tabline#enabled = 1
set t_Co=256
set laststatus=2        " 常にステータスラインを表示

" let g:auto_ctags = 1    " ファイル保存時に自動的にCtagsを実行
" let g:auto_ctags_directory_list = ['.git', '.svn'] "バージョン管理外のディレクトリに保存
" set tags+=.svn/tags
nnoremap <C-]> g<C-]>   " 候補が複数ある場合は候補を表示する

let Tlist_Show_One_File = 1             "現在表示中のファイルのみのタグしか表示しない
let Tlist_Use_Right_Window = 1          "右側にtag listのウインドうを表示する
let Tlist_Exit_OnlyWindow = 1           "taglistのウインドウだけならVimを閉じる
nnoremap <silent> tl :TlistToggle<CR>   "tlでtaglistウインドウを開閉


"-------------------------------------------------------------------------------
" Configration: develop
"
" Plugin: Switch        - switch keyword (ex. true <-> false)
" Plugin: SplitJoin     - 1行コード <-> 複数行の切替
" Plugin: tcomment_vim  - コメントON/OFFを手軽に実行 (<Ctl> --)
" Plugin: surround.vim  - シングルクォートとダブルクォートを切替 (cs'")
" Plugin: vim-endwise   - endを自動挿入
" Plugin: Align         - 高機能整形 桁揃え
" Plugin: vim-alignta   - マルチバイト対応の整形
" Plugin: SQLUtilities  - SQL整形 生成ユーティリティ
" Plugin: vim-ruby      - Rubyのオムニ変換を行うためのプラグイン
" Plugin: vim-rails     - RailsのModel-View-Controllerの移動補佐 (:Rmodel ...etc)
" Plugin: unite-rails   - Rails
"-------------------------------------------------------------------------------

nnoremap <silent> -   :Switch<CR>

nmap gj :SplitjoinJoin<cr>
nmap gk :SplitjoinSplit<cr>
" let g:splitjoin_split_mapping = ''
" let g:splitjoin_join_mapping = ''
" nmap <Leader>j :SplitjoinJoin<cr>
" nmap <Leader>s :SplitjoinSplit<cr>

"nnoremap <silent> rm  :Rmodel<CR>
"nnoremap <silent> rc  :Rcontroller<CR>
"nnoremap <silent> rv  :Rview<CR>
"nnoremap <silent> rs  :Rspec<CR>


"-------------------------------------------------------------------------------
" Plugin: Others
"-------------------------------------------------------------------------------

filetype plugin indent on     "Required: ファイルタイプ判定をon

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.


"-----------------------------------------------------------
" Configration: 基本設定 Basics
"-----------------------------------------------------------
set scrolloff=5         " スクロール時の余白確保
set textwidth=0         " 一行に長い文章を書いていても自動折り返しをしない
set autoread            " 他で書き換えられたら自動で読み直す
set hidden              " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq  " テキスト整形オプション、マルチバイト系を追加
set showcmd             " コマンドをステータス行に表示
set showmode            " 現在のモードを表示

" meta file
" http://nanasi.jp/articles/howto/file/seemingly-unneeded-file.html
" http://www.kaoriya.net/blog/2014/03/30/
set nobackup                " バックアップ機能を有効化
set backupdir=~/.vim/backup " バックアップファイルの出力先
set undofile                " undo機能を有効化
set undodir=~/.vim/undo     " undoファイルの保存先 (vim 7.4 later)
"set nobackup               " バックアップ取らない
"set noswapfile             " スワップファイルを作らない (他セッションで開いた時に厄介なので解除)

" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

" OSのクリップボードを使用する
" ヤンクした文字は、システムのクリップボードに入れる
set clipboard+=unnamed
set clipboard+=autoselect
" set clipboard=unnamedplus,autoselect

" 挿入モードで Ctrl+k を押すとクリップボードの内容を貼り付けられるようにする
" neocomplcacheと被るのでコメントアウト
"imap <C-K> <ESC>"*pa

"Window分割
set splitbelow
set splitright


"-----------------------------------------------------------
"Configration:  表示 Apperance
"-----------------------------------------------------------
"colorscheme desert "カラースキーマ
set showmatch       " 括弧の対応をハイライト
set number          " 行番号表示
set display=uhex    " 印字不可能文字を16進数で表示
set lazyredraw      " コマンド実行中は再描画しない
set ttyfast         " 高速ターミナル接続を行う

syntax enable       " シンタックスカラーをON

" 不可視文字表示
set list
set listchars=tab:>\ \,trail:_,extends:>,precedes:<


augroup templates
  autocmd!
  autocmd BufNewFile *.rb 0r ~/.vim/templates/rb.tpl
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

" 保存時に行末の空白を除去する
if &ft != 'markdown'
  autocmd BufWritePre * :%s/\s\+$//ge
endif

" 全角スペースの表示
" http://inari.hatenablog.com/entry/2014/05/05/231307
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
    " highlight Zenkakuspace cterm=underline ctermfg=white ctermbg=black
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif


" カーソル行を表示
" カレントウィンドウにのみ罫線を引く
set cursorline
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END
:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
highlight CursorLine gui=underline guifg=NONE guibg=NONE

" makeした後でQuickFixを自動的に開く
augroup QuickfixOpen
  autocmd!
  autocmd QuickFixCmdPost make cw
augroup END


"-----------------------------------------------------------
" Configration: インデント Indent
"-----------------------------------------------------------
set autoindent          " 自動でインデント
set smartindent         " 新しい行のインデントを現在行と同じ量にする
" set paste             " ペースト時にautoindentを無効にする
set tabstop=2           " Tabの表示幅
set shiftwidth=2        " インデント幅設定
set expandtab           " TABをSpaceに

"-----------------------------------------------------------
" Configration: 検索設定 Search
"-----------------------------------------------------------
set wrapscan        " 最後まで検索したら先頭へ戻る
set ignorecase      " 大文字小文字無視
set smartcase       " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch       " インクリメンタルサーチ
set hlsearch        " 検索文字をハイライト

" Escの2回押しでハイライト消去
nnoremap <ESC><ESC> :nohlsearch<CR><ESC>


"-----------------------------------------------------------
" Configration: カーソル移動 CursolMove
"-----------------------------------------------------------
" 括弧を入力時、カーソルを左シフト
inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap <> <><Left>

" 左括弧を入力時、右カッコを自動入力
" => 邪魔なのでコメントアウト
"inoremap { {}<Left>
"inoremap [ []<Left>
"inoremap ( ()<Left>
"inoremap " ""<Left>
"inoremap ' ''<Left>
"inoremap < <><Left>

" matchitを有効化. def-end なども%で移動できるようにする
if !exists('loaded_matchit')
  runtime macros/matchit.vim
endif

set backspace=indent,eol,start " mac で terminal からvim利用時にbackspaceキーが効かなくなる現象の対応

"-------------------------------------------------------------------------------
" Configration: エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac    " 改行文字
set encoding=utf-8      " デフォルトエンコーディング

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

set fileformats=unix,dos,mac    " 改行コードの自動認識

" ■や●などのマルチコード表示時もカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif


"-------------------------------------------------------------------------------
" Configration: 編集関連 Edit
"-------------------------------------------------------------------------------

" insertモードを抜けると、IMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
"inoremap <silent> <unique> <ESC> <ESC>:set imsearch=0 iminsert=0<CR>

"-----------------------------------------------------------
" Configration: ステータスライン StatusLine
"-----------------------------------------------------------
"set ruler		" カーソルが何行目の何列目に置かれているかを表示する
"
"" ステータスラインに文字コードと改行文字を表示する
"if winwidth(0) >= 120
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
"else
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
"endif
"
"augroup InsertHook
"  autocmd!
"  autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
"  autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
"augroup END
"function! GetB()
"  let c = matchstr(getline('.'), '.', col('.') - 1)
"  let c = iconv(c, &enc, &fenc)
"  return String2Hex(c)
"endfunction
"
"func! Nr2Hex(nr)
"  let n = a:nr
"  let r = ""
"  while n
"    let r = '0123456789ABCDEF'[n % 16] . r
"    let n = n / 16
"  endwhile
"  return r
"endfunc
"
"func! String2Hex(str)
"  let out = ''
"  let ix = 0
"  while ix < strlen(a:str)
"    let out = out . Nr2Hex(char2nr(a:str[ix]))
"    let ix = ix + 1
"  endwhile
"  return out
"endfunc
