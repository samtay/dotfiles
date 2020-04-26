""" Install vimplug if necessary """
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

""""""""""" Custom added plugins """"""""""""""""""""
" utils
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'inkarkat/vim-SyntaxRange'
Plug 'inkarkat/vim-ingo-library'
Plug 'airblade/vim-rooter'

" spacemacs
Plug 'hecal3/vim-leader-guide'
Plug 'jimmay5469/vim-spacemacs'

" color
Plug 'liuchengxu/space-vim-dark'
Plug 'vim-scripts/mayansmoke'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

" haskell
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'parsonsmatt/vim2hs'

" coq ?
" check back after neovim support added
" Plug 'whonore/Coqtail' | Plug 'let-def/vimbufsync'
Plug 'https://framagit.org/tyreunom/coquille.git'

" tex
Plug 'lervag/vimtex', { 'for': 'tex' }

" nix
Plug 'LnL7/vim-nix'

" tabular formatting
Plug 'godlygeek/tabular'

" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'samtay/vim-snippets'

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
" Just hide buffers
set noswapfile
set hidden
" Remember info about open buffers on close
set viminfo^=%
" Status line always shows
set laststatus=2

""""" default 2 spaces
filetype plugin indent on
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2

" better splits mgmt
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Don't auto comment for the love of god
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" No concealment?
set cole=0
au FileType * setl cole=0
" Fix ^G characters in nerdtree buffer
augroup my_nerdtree
  au!
  au FileType nerdtree setl cole=2
augroup END

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
augroup END

" Delete whitespace when saving haskell files
augroup whitespace
  autocmd!
  autocmd BufWrite * :call DeleteTrailingWS()
augroup END

" Colors
if (has("termguicolors"))
  set termguicolors
endif
let g:gruvbox_italic=1
set background=dark
colorscheme gruvbox
hi Comment cterm=italic


"""""""""""""""""""""""""""" Plugin Settings """"""""""""""""""""
" Use deoplete / snippets.
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/git/vim-snippets/snippets'
" Tabbing snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><CR>
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"
imap <expr><CR>
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"

" Use powerline fonts for airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 0
let g:airline_symbols.space = "\ua0"
" Set airline theme
let g:airline_theme='gruvbox'

" Easy motions
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
" nmap s <Plug>(easymotion-overwin-f)

" FZF settings
let g:fzf_layout = { 'down': '~35%' }

" Limelight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
let g:limelight_default_coefficient = 0.7

" Haskell plugin settings
" TODO move haskell stuff to ftplugin
" conceal
let g:haskell_conceal = 1
let g:haskell_conceal_wide = 1
set nofoldenable
" indent
let g:haskell_indent_if = 0
let g:haskell_indent_in = 0
let g:haskell_indent_let = 4
let g:haskell_indent_case_alternative = 1
let g:haskell_tabular = 0
" highlighting
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`


"""""""""""""""""""""""""""" Functions """"""""""""""""""""
" Utility function to delete trailing white space
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

function! ConcealToggle()
  if &conceallevel
    setlocal conceallevel=0
  else
    setlocal conceallevel=1
  endif
endfunction

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

function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction


"""""""""""""""""""""""""""" Alias Settings """"""""""""""""""""
" Save read-only files easily
cmap w!! w !sudo tee > /dev/null %
" New lines without insert mode
map <Enter> o<ESC>
" Damn this doesn't work
map <C-Enter> O<ESC>
" leader
map <SPACE> <leader>


"""""""""""""""""""""""""""" Leader Settings """"""""""""""""""""
" TODO remove after porting custom spacemacs
let g:spacemacs#excludes = [
  \ '^pf',
  \ '^bf',
  \ '^fr',
  \ '^ff',
  \ '^ft',
  \ '^tn',
  \ '^cc',
  \ '^gd',
  \ '^j=',
  \ '^tl',
  \ ]

" files
nnoremap <leader>fp :Files<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>ft :call NERDTreeToggleInCurDir()<CR>
" buffers
nnoremap <leader>bf :Buffers<CR>
" search
nnoremap <leader>/ :execute 'Ag ' . input('Ag/')<CR>
" window/pane stuff
nnoremap <leader>wH <C-W>H
nnoremap <leader>wK <C-W>K
nnoremap <leader>wL <C-W>L
nnoremap <leader>wJ <C-W>J
nnoremap <leader>w_ <C-W>_
nnoremap <leader>w\| <C-W>\|
nnoremap <leader>w<CR> <C-W>o
" tags
nnoremap <leader>gt <C-]>
nnoremap <leader>gT g]
" comment tools
nnoremap <leader>cc :call NERDComment('n', "Toggle")<CR>
vnoremap <leader>cc :call NERDComment('v', "Toggle")<CR>
" toggles
nnoremap <leader>tn :call NumberToggle()<CR>
nnoremap <leader>tc :call ConcealToggle()<cr>
nnoremap <leader>ts :noh<cr>
nnoremap <leader>tg :Goyo<cr>
nnoremap <leader>tl :Limelight!!<cr>
" copy/paste
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P
" easy motion searches
nmap <Leader>s <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" align tools
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a; :Tabularize /::<CR>
vnoremap <leader>a- :Tabularize /-><CR>
vnoremap <leader>a, :Tabularize /,<CR>
vnoremap <leader>ac :Tabularize /--<CR>
" edit vimrc quickly
map <leader>v :sp ~/.config/nvim/init.vim<cr>
" and reload vimrc when saved
au BufWritePost init.vim so ~/.config/nvim/init.vim
" haskell
au FileType haskell nnoremap <leader>ha ms:%!stylish-haskell<CR>'s
au FileType haskell nnoremap <leader>hc :HoogleClose<CR>
au FileType haskell nnoremap <leader>hh :Hoogle<CR>
au FileType haskell nnoremap <leader>hi :HoogleInfo<CR>
