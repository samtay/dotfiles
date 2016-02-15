set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

""""""""""" Custom added plugins """"""""""""""""""""
Plugin 'morhetz/gruvbox'
" Plugin 'zeis/vim-kolor'


""""""""" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""" Personal Vim Settings """"""""""""""""""""
" Show line numbers by default
set number

" Don't auto comment for the love of god
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set tabbing preferences
filetype plugin indent on
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2

" New lines without insert mode
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" Colors
set t_Co=256
set background=dark
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=0                " Enable underline. Default: 0
let g:kolor_alternative_matchparen=0    " Gray 'MatchParen' color. Default: 0
colorscheme gruvbox

" Save read-only files easily
cmap w!! w !sudo tee > /dev/null %
