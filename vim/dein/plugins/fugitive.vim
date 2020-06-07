nnoremap [fugitive] <Nop>
nmap <C-g> [fugitive]
nnoremap <silent> [fugitive]s :Gstatus<CR><C-w>T  " git status
nnoremap <silent> [fugitive]a :Gwrite<CR>         " git add [FILE_NAME]
nnoremap <silent> [fugitive]c :Gcommit-v<CR>      " git commit
nnoremap <silent> [fugitive]b :Gblame<CR>         " git blame [FILE_NAME]
nnoremap <silent> [fugitive]d :Gvdiff<CR>         " git diff -v [FILE_NAME]
nnoremap <silent> [fugitive]m :Gmerge<CR>         " git merge
nnoremap <silent> [fugitive]l :Gllog<CR>          " git log
nnoremap <silent> [fugitive]p :Gpush<CR>          " git push
nnoremap <silent> [fugitive]r :Gread<CR>          " git checkout [FILE_NAME]
