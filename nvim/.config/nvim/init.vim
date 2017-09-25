call plug#begin('~/.local/share/nvim/plugged')

""""""""""" Custom added plugins """"""""""""""""""""
" utils
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
" spacemacs
Plug 'hecal3/vim-leader-guide'
Plug 'jimmay5469/vim-spacemacs'
" color
" Plug 'colepeters/spacemacs-theme.vim'
Plug 'liuchengxu/space-vim-dark'
Plug 'vim-scripts/mayansmoke'
" Plug 'urso/haskell_syntax.vim' UNCOMMENT FOR vim, COMMENT FOR nvim
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
" nix
Plug 'LnL7/vim-nix'
" tabular formatting
Plug 'godlygeek/tabular'
" autocomplete tabs
Plug 'ervandew/supertab'
" haskell (might be more suitable for personal projects)
" Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
" Plug 'bitc/vim-hdevtools', { 'for': 'haskell' }
" Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
" elm
" Plug 'ElmCast/elm-vim'
" syntax checker
" Plug 'scrooloose/syntastic'
" fuzzy filesystem finder
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

" No swap -- this was biting me
" set noswapfile
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
" augroup whitespace
"   autocmd!
"   autocmd BufWrite *.hs :call DeleteTrailingWS()
" augroup END

" Use powerline fonts for airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
" Set airline theme
let g:airline_theme='angr'

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

" New lines without insert mode
map <Enter> o<ESC>
" Damn this doesn't work
map <C-Enter> O<ESC>

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

" comment tools
nnoremap <leader>cc :call NERDComment('n', "Toggle")<CR>
vnoremap <leader>cc :call NERDComment('v', "Toggle")<CR>

" toggles
nnoremap <leader>tn :call NumberToggle()<CR>
nnoremap <leader>tc :call ConcealToggle()<cr>
nnoremap <leader>ts :setlocal spell!<cr>

" align tools
let g:haskell_tabular = 0
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a; :Tabularize /::<CR>
vnoremap <leader>a- :Tabularize /-><CR>
vnoremap <leader>a, :Tabularize /,<CR>
" format stylish haskell
nnoremap <leader>ash :%!stylish-haskell<CR>

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
hi clear Conceal
let g:haskell_conceal_wide = 1
let g:haskell_conceal_enumerations = 1
let hscoptions="𝐒𝐓𝐄𝐌xRtB𝔻wr↱"
set conceallevel=0

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
