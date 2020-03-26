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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'inkarkat/vim-SyntaxRange'
Plug 'inkarkat/vim-ingo-library'

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

" tex
Plug 'lervag/vimtex', { 'for': 'tex' }

" nix
Plug 'LnL7/vim-nix'

" tabular formatting
Plug 'godlygeek/tabular'

" Autocomplete
" Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'samtay/vim-snippets'

" syntax checker
" Plug 'w0rp/ale'
" Plug 'scrooloose/syntastic'
"Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
"Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}

" coq
" Plug 'let-def/vimbufsync'
" Plug 'the-lambda-church/coquille'


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

" Use deoplete.
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

set noswapfile
" Just hide buffers
set hidden

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
  autocmd BufWrite * :call DeleteTrailingWS()
augroup END

" Use powerline fonts for airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 0
let g:airline_symbols.space = "\ua0"
" Set airline theme
let g:airline_theme='gruvbox'

" Toggle tagbar
nmap <leader>t :TagbarToggle<CR>

"""""""" Aliases """""""
" leader
map <SPACE> <leader>
" edit vimrc quickly
map <leader>v :sp ~/.config/nvim/init.vim<cr>
" reload vimrc when saved
au BufWritePost init.vim so ~/.config/nvim/init.vim

" Leader shortcuts for copy pasting
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

" Save read-only files easily
cmap w!! w !sudo tee > /dev/null %

" New lines without insert mode
map <Enter> o<ESC>
" Damn this doesn't work
map <C-Enter> O<ESC>

" Easy motions
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" nmap s <Plug>(easymotion-overwin-f)
nmap <Leader>s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

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

let g:gruvbox_italic=1
set background=light
colorscheme gruvbox

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
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/.stack-work/* TODO hopefully this fixes fucking nvim freezing
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
  \ '^ft',
  \ '^tn',
  \ '^cc',
  \ '^gd',
  \ ]
" fzf
nnoremap <leader>pf :Files<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>ft :call NERDTreeToggleInCurDir()<CR>
nnoremap <leader>bf :Buffers<CR>
nnoremap <leader>/ :execute 'Ag ' . input('Ag/')<CR>

" window/split stuff
nnoremap <leader>wH <C-W>H
nnoremap <leader>wK <C-W>K
nnoremap <leader>wL <C-W>L
nnoremap <leader>wJ <C-W>J
nnoremap <leader>w_ <C-W>_
nnoremap <leader>w\| <C-W>\|
nnoremap <leader>w<CR> <C-W>o

nnoremap <leader>gt <C-]>
nnoremap <leader>gT g]

" comment tools
nnoremap <leader>cc :call NERDComment('n', "Toggle")<CR>
vnoremap <leader>cc :call NERDComment('v', "Toggle")<CR>

" toggles
nnoremap <leader>tn :call NumberToggle()<CR>
nnoremap <leader>tc :call ConcealToggle()<cr>
nnoremap <leader>ts :noh<cr>

 """ TODO move haskell stuff to ftplugin

" align tools
let g:haskell_tabular = 0
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a; :Tabularize /::<CR>
vnoremap <leader>a- :Tabularize /-><CR>
vnoremap <leader>a, :Tabularize /,<CR>
vnoremap <leader>ac :Tabularize /--<CR>
" formatting
nnoremap <leader>ah ms:%!stylish-haskell<CR>'s

" hdevtools
let g:hdevtools_options = '-g -ifrontend/src -g -icommon/src -g -ibackend/src -g -Wall'
au FileType haskell nnoremap <leader>ht :HdevtoolsType<CR>
au FileType haskell nnoremap <leader>hc :HoogleClose<CR>:HdevtoolsClear<CR>
au FileType haskell nnoremap <leader>hi :HdevtoolsInfo<CR>

" hoogle
au FileType haskell nnoremap <leader>hh :Hoogle<CR>
au FileType haskell nnoremap <leader>hi :HoogleInfo<CR>

" leader guide (broken)
" nnoremap <silent> <leader> :<C-U>LeaderGuide '<SPACE>'<CR>
" vnoremap <silent> <leader> :<C-U>LeaderGuideVisual '<SPACE>'<CR>

""""""" Haskell stuff
" conceal
" hi clear Conceal
" let g:haskell_conceal_wide = 1
" let g:haskell_conceal_enumerations = 1
" let hscoptions="𝐒𝐓𝐄𝐌xRtB𝔻wr↱"
" set conceallevel=0
let g:haskell_conceal = 1
let g:haskell_conceal_wide = 1
set nofoldenable

" indent
let g:haskell_indent_if = 0
let g:haskell_indent_in = 0
let g:haskell_indent_let = 4
let g:haskell_indent_case_alternative = 1
" highlighting
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`

""""""" Autocompletion settings
" Try omnifunc, else fallback to keywords
" autocmd FileType *
"       \ if &omnifunc != '' |
"       \   call SuperTabChain(&omnifunc, "<c-p>") |
"       \ endif

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

set cole=0
au FileType * setl cole=0

augroup my_nerdtree
  au!
  au FileType nerdtree setl cole=2
augroup END
