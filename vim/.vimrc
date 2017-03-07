call plug#begin('~/.vim/plugged')

""""""""""" Custom added plugins """"""""""""""""""""
Plug 'scrooloose/syntastic'
" autocomplete tabs
Plug 'ervandew/supertab'
" tabular formatting
Plug 'godlygeek/tabular'
" fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
" elm
Plug 'ElmCast/elm-vim'
" haskell
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}


""""""""""" End plugins """""""""""""""""""""""""""""
call plug#end()


"""""""""""""""""""""""""""" Personal Vim Settings """"""""""""""""""""
filetype plugin indent on
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
map <C-Enter> O<ESC>

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

" better splits mgmt
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

""""""" Colors
set t_Co=256
set background=dark
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=0                " Enable underline. Default: 0
let g:kolor_alternative_matchparen=0    " Gray 'MatchParen' color. Default: 0
colorscheme Tomorrow-Night-Eighties

"""""" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:elm_syntastic_show_warnings = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

""""""" Ctrl P settings
let g:ctrlp_show_hidden = 1

"""""""" haskell
" ghc-mod
map <Leader>q :GhcModType<CR>
map <Leader>w :GhcModTypeInsert<CR>
map <Leader>s :GhcModSplitFunCase<CR>
map <Leader>e :SyntasticReset<CR>:ccl<CR>:GhcModTypeClear<CR>
"let g:ghcmod_hlint_options = []
let g:ghcmod_hlint_options = ['--ignore=Move brackets to avoid $', '--ignore=Redundant $', '--ignore=Redundant bracket']
autocmd BufWritePost *.hs GhcModCheckAndLintAsync
" tabularize
let g:haskell_tabular = 1
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>
vmap a, :Tabularize /,<CR>

""""""""" latex
function ReloadLatex()
  :w
  :!pdflatex %
endfunc
au FileType tex cmap rt call ReloadLatex()

""""""" Set tabbing preferences
""""" default 2 spaces
filetype plugin indent on
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2
