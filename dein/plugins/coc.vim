"スペース2回でCocList
nmap <silent> <space><space> :<C-u>CocList<cr>
"スペースhでHover
nmap <silent> <space>ch :<C-u>call CocAction('doHover')<cr>
"スペースdfでDefinition
nmap <silent> <space>cdf <Plug>(coc-definition)
"スペースrfでReferences
nmap <silent> <space>crf <Plug>(coc-references)
"スペースrnでRename
nmap <silent> <space>crn <Plug>(coc-rename)
"スペースfmtでFormat
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
" Remap for rename current word
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction<space>fmt <Plug>(coc-format)

let g:coc_global_extensions = [
  \  'coc-yank'
  \, 'coc-json'
  \, 'coc-tsserver'
  \, 'coc-snippets'
  \, 'coc-prettier'
  \, 'coc-pairs'
  \, 'coc-fzf-preview'
  \, 'coc-explorer'
  \, 'coc-rust-analyzer'
  \, 'coc-python'
  \, ]
