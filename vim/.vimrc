set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

""""""""""" Custom added plugins """"""""""""""""""""
Plugin 'morhetz/gruvbox'
Plugin 'scrooloose/syntastic'
Plugin 'bitc/vim-hdevtools'
"Plugin 'itchyny/vim-haskell-indent'
Plugin 'neovimhaskell/haskell-vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'StanAngeloff/php.vim'
Plugin 'ElmCast/elm-vim'
" Plugin 'lambdatoast/elm.vim'
" Plugin 'zeis/vim-kolor'


""""""""" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""" Personal Vim Settings """"""""""""""""""""
" Show line numbers by default
set relativenumber
set number
set showcmd

" Don't auto comment for the love of god
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"""""""" Aliases """""""
" leader
map <SPACE> <leader>
" select all text in buffer
map <Leader>a ggVG
" edit vimrc quickly
map <leader>v :sp ~/.vimrc<cr>
" reload vimrc when saved
au BufWritePost .vimrc so ~/.vimrc

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
  elseif(&rnu == 0 && &nu == 1)
    set rnu
  else
    set nornu
    set nonu
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

"""""" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

"""""""" vim-hdevtools
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>

""""""""" latex
function ReloadLatex()
  :w
  :!pdflatex %
endfunc
au FileType tex cmap retex call ReloadLatex()

""""""" Set tabbing preferences
""""" default 2 spaces
filetype plugin indent on
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2
