let g:airline_theme = 'papercolor'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
nmap <C-n> <Plug>AirlineSelectNextTab
nmap <C-p> <Plug>AirlineSelectPrevTab
