call plug#begin('~/.local/share/nvim/plugged')

""""""""""" Custom added plugins """"""""""""""""""""
" utils
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
" spacemacs ?
Plug 'hecal3/vim-leader-guide'
Plug 'jimmay5469/vim-spacemacs'
" color
" Plug 'colepeters/spacemacs-theme.vim'
Plug 'liuchengxu/space-vim-dark'
" haskell
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
" nix
Plug 'LnL7/vim-nix'
" uncomment after ctags
Plug 'majutsushi/tagbar'
" elm
" Plug 'ElmCast/elm-vim'
" syntax checker
" Plug 'scrooloose/syntastic'
" autocomplete tabs
" Plug 'ervandew/supertab'
" fuzzy filesystem finder
"Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
"Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
" coq
" Plug 'let-def/vimbufsync'
" Plug 'the-lambda-church/coquille'
" tabular formatting
" Plug 'godlygeek/tabular'


""""""""""" End plugins """""""""""""""""""""""""""""
call plug#end()


"""""""""""""""""""""""""""" Personal Vim Settings """"""""""""""""""""
filetype plugin indent on
" Show line numbers by default
set relativenumber
set number
set showcmd
" indenting
set ai
set si

""""" default 2 spaces
filetype plugin indent on
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2

" Don't auto comment for the love of god
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" No swap
set noswapfile

" Return to last edit position when opening files (You want this!)
augroup last_edit
  autocmd!
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
augroup END

" Remember info about open buffers on close
set viminfo^=%

" Status line always shows
set laststatus=2

" Utility function to delete trailing white space
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
" use it on saving haskell files
augroup whitespace
  autocmd!
  autocmd BufWrite *.hs :call DeleteTrailingWS()
augroup END

" Use powerline fonts for airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
" Set airline theme
"let g:airline_theme='tomorrow'
let g:airline_theme='base16_eighties'

" Toggle tagbar
nmap <leader>t :TagbarToggle<CR>

"""""""" Aliases """""""
" leader
map <SPACE> <leader>
" edit vimrc quickly
map <leader>v :sp ~/.config/nvim/init.vim<cr>
" reload vimrc when saved
au BufWritePost .vimrc so ~/.vimrc

" Leader shortcuts for copy pasting
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

" Save read-only files easily
cmap w!! w !sudo tee > /dev/null %
" Comment command with '#' by default
cmap comment s/^/#/

" Toggle spell checking
map <leader>s :setlocal spell!<cr>

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

" find current selection
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

""""""" Colors
if (has("termguicolors"))
  set termguicolors
endif
set t_Co=256
" let g:kolor_italic=1                    " Enable italic. Default: 1
" let g:kolor_bold=1                      " Enable bold. Default: 1
" let g:kolor_underlined=0                " Enable underline. Default: 0
" let g:kolor_alternative_matchparen=0    " Gray 'MatchParen' color. Default: 0
set background=dark
colorscheme space-vim-dark
hi Comment cterm=italic

""""""" Ctrl P settings
" ali's settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_lazy_update = 10
nnoremap <C-o> :CtrlPBuffer<CR>
inoremap <C-o> <Esc>:CtrlPBuffer<CR>
" default hidden stuff
let g:ctrlp_show_hidden = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/.stack-work/*
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|stack-work)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
" ag + aspen
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --smart-case
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden --smart-case
                              \ --ignore .git
                              \ --ignore .svn
                              \ --ignore .hg
                              \ --ignore amazonka
                              \ --ignore="*.dyn_hi"
                              \ --ignore="*.dyn_o"
                              \ --ignore="*.p_hi"
                              \ --ignore="*.p_o"
                              \ --ignore="*.hi"
                              \ --ignore="*.o"
                              \ -g ""'
endif

""""""" FZF settings
let g:fzf_layout = { 'down': '~35%' }

""""""" Spacemacs shiz
let g:spacemacs#excludes = [
  \ '^pf',
  \ '^bf',
  \ '^fr',
  \ '^ff',
  \ ]
nnoremap <leader>pf :Files<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>bf :Buffers<CR>


""""""" Autocompletion settings
" Try omnifunc, else fallback to keywords
" autocmd FileType *
"       \ if &omnifunc != '' |
"       \   call SuperTabChain(&omnifunc, "<c-p>") |
"       \ endif
