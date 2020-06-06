let mapleader = "\<Space>"
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
" git ls-files result
nnoremap <Leader>g :GFiles<CR>
" git status result
nnoremap <Leader>s :GFiles?<CR>
" line in loaded buffer
nnoremap <Leader>l :Lines<CR>
" ag search result
nnoremap <Leader>a :Ag<CR>
" kill buffer
nnoremap <Leader>k :bd<CR>

" most recently used interface
command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})
nnoremap <Leader>r :FZFMru<CR>

" custom file finder
" command! FZFFileList call fzf#run({
"             \ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
"             \ 'sink': 'e'})
command! FZFFileList call fzf#run({
            \ 'source': 'ag --hidden --ignore .git -g ""',
            \ 'sink': 'e'})
nnoremap <Leader>f :FZFFileList<CR>

