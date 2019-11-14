nnoremap [fugitive] <Nop>
nmap <C-g> [fugitive]
" git status
nnoremap <silent> [fugitive]s :Gstatus<CR><C-w>T
" git add [FILE_NAME]
nnoremap <silent> [fugitive]a :Gwrite<CR>
" git commit
nnoremap <silent> [fugitive]c :Gcommit-v<CR>
" git blame [FILE_NAME]
nnoremap <silent> [fugitive]b :Gblame<CR>
" git diff -v [FILE_NAME]
nnoremap <silent> [fugitive]d :Gvdiff<CR>
" git merge
nnoremap <silent> [fugitive]m :Gmerge<CR>
nnoremap <silent> [fugitive]l :Gllog<CR>
" git push
nnoremap <silent> [fugitive]p :Gpush<CR>
" git checkout [FILE_NAME]
nnoremap <silent> [fugitive]r :Gread<CR>
