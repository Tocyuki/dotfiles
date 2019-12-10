nnoremap [denite] <Nop>
nmap <C-d> [denite]
nnoremap <silent> [denite]g :<C-u>Denite grep -buffer-name=search-buffer-denite -mode=normal<CR>
nnoremap <silent> [denite]f :<C-u>Denite file_rec -mode=normal<CR>
nnoremap <silent> [denite]d :<C-u>Denite directory_rec -mode=normal<CR>
nnoremap <silent> [denite]b :<C-u>Denite buffer -mode=normal<CR>
nnoremap <silent> [denite]h :<C-u>Denite command_history<CR>
nnoremap <silent> [denite]c :<C-u>Denite command<CR>
