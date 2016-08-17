set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

""""""""""" Custom added plugins """"""""""""""""""""
Plugin 'morhetz/gruvbox'
Plugin 'StanAngeloff/php.vim'
" Plugin 'zeis/vim-kolor'


""""""""" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""" Personal Vim Settings """"""""""""""""""""
" Show line numbers by default
set relativenumber

" Don't auto comment for the love of god
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set tabbing preferences
filetype plugin indent on
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2

"""""""" Aliases """""""

" Save read-only files easily
cmap w!! w !sudo tee > /dev/null %
" Comment command with '#' by default
cmap comment s/^/#/
" New lines without insert mode
map <Enter> o<ESC>
" Damn this doesn't work
map <S-Enter> O<ESC>

" copy to buffer
vmap <C-c> :w! ~/.vimbuffer<CR>
nmap <C-c> :.w! ~/.vimbuffer<CR>
" paste from buffer
map <C-p> :r ~/.vimbuffer<CR>

function! NumberToggle()
  if(&rnu == 0 && &nu == 0)
    set nu
  elseif(&nu == 1)
    set nonu
    set rnu
  else
    set nornu
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<CR>

""""""" Colors
set t_Co=256
set background=dark
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=0                " Enable underline. Default: 0
let g:kolor_alternative_matchparen=0    " Gray 'MatchParen' color. Default: 0
colorscheme brogrammer
