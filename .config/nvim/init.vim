""" Install vimplug if necessary """
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
""""""""""" Begin plugins """"""""""""""""""""
" TODO go through and trim these...

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
Plug 'tpope/vim-obsession'
Plug 'Yggdroot/indentLine'
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line'
Plug 'ledger/vim-ledger'

" spacemacs
" This plugin kinda sucks, just remove it maybe?
Plug 'hecal3/vim-leader-guide'

" color
Plug 'liuchengxu/space-vim-dark'
Plug 'vim-scripts/mayansmoke'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

" haskell
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'neovimhaskell/haskell-vim'
Plug 'sdiehl/vim-ormolu'

" ts
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" rust
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" coq ?
" check back after neovim support added
" Plug 'whonore/Coqtail' | Plug 'let-def/vimbufsync'
Plug 'https://framagit.org/tyreunom/coquille.git'

" tex
Plug 'lervag/vimtex', { 'for': 'tex' }

" nix
Plug 'LnL7/vim-nix'

" souffle/datalog
Plug 'souffle-lang/souffle.vim'

" formatting
Plug 'godlygeek/tabular' " TODO replace with junegunn/vim-easy-align
Plug 'aetherknight/neoformat'

" Autocomplete
" TODO move these to nvim-cmp?
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': 'tex' }
"Plug 'Shougo/neosnippet.vim', {'for': 'tex'}
"Plug 'Shougo/neosnippet-snippets', {'for': 'tex'}
"Plug 'samtay/vim-snippets', {'for': 'tex'}

" language server
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'hrsh7th/nvim-cmp'
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'onsails/lspkind-nvim'

" Snippet stuff
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

" popup selectors
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" just
Plug 'NoahTheDuke/vim-just'

""""""""""" End plugins """""""""""""""""""""""""""""
call plug#end()


"""""""""""""""""""""""""""" Include lua cfg """"""""""""""""""""""""""
lua require("cfg")

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
syntax on
set expandtab
set softtabstop=2
set shiftwidth=2

" resize splits more easily (more split mgmt below via <leader>w)
nnoremap <C-J> <C-W>-
nnoremap <C-K> <C-W>+
nnoremap <C-L> <C-W>>
nnoremap <C-H> <C-W><
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

" nvim-cmp completion settings

 " Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

" Use powerline fonts for airline?
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
" Set airline theme
let g:airline_theme='gruvbox'
function! LspStatus() abort
  let status = luaeval('require("lsp-status").status()')
  return trim(status)
endfunction
call airline#parts#define_function('lsp_status', 'LspStatus')
call airline#parts#define_condition('lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')
let g:airline#extensions#nvimlsp#enabled = 0
let g:airline_section_warning = airline#section#create_right(['lsp_status'])
function! AirlineInit()
    let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" ident line visuals
let g:indentLine_char = '│'

" Easy motions
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1

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

" Rooter
let g:rooter_patterns = ['Cargo.toml', 'Rakefile', 'stack.yaml', 'Gemfile', '.git/']

" Rust
let g:rustfmt_autosave = 1

" Coq plugin settings
let g:coquille_auto_move = "true"
hi default CheckedByCoq ctermbg=11 guibg=LightGreen
hi default SentToCoq ctermbg=13 guibg=LimeGreen


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

function! NCoqNext()
  " looks weird without v:count1, just avoiding sleep on default call
  exe ":CoqNext"
  for i in range(1, v:count) | sleep 200m | exe ":CoqNext" | endfor
endfunction

function! NCoqUndo()
  exe ":CoqUndo"
  for i in range(1, v:count) | sleep 200m | exe ":CoqUndo" | endfor
endfunction

function! Simformat()
  let l:pos=getpos(".")
  exe "%!simformat -e"
  call setpos(".", l:pos)
endfunc

function! Get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
      return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

"""""""""""""""""""""""""""" Alias Settings """"""""""""""""""""
" Save read-only files easily
cmap w!! w !sudo tee > /dev/null %
" New lines without insert mode
map <CR> o<ESC>k
map <S-CR> O<ESC>j
" leader
map <SPACE> <leader>

"""""""""""""""""""""""""""" Leader Settings """"""""""""""""""""
" files / telescope nav
nnoremap <leader>ft :call NERDTreeToggleInCurDir()<CR>
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope git_files<CR>
nnoremap <leader>fr <cmd>Telescope oldfiles<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fs :w<CR>
nnoremap <leader>fS :wa<CR>
nnoremap <leader>fe :!"%:p"<CR>
nnoremap <leader>m <cmd>Telescope marks<CR>
" buffers
nnoremap <leader>bx :%bd\|e#\|bd#<CR>
nnoremap <leader>bd :bdelete<CR>
" search for string
nnoremap <leader>/ <cmd>Telescope live_grep<CR>
"xnoremap <leader>/ <cmd>Telescope grep_string<CR>
vnoremap <leader>/ "zy<cmd>exec 'Telescope grep_string default_text=' . escape(@z, ' ')<cr>
" help with keymaps
nnoremap <leader>? <cmd>Telescope keymaps<CR>
nnoremap <leader>? <cmd>Telescope keymaps<CR>
" git stuff
nnoremap <leader>gs <cmd>Telescope git_status<CR>
nnoremap <leader>gc <cmd>Telescope git_commits<CR>
" lsp nav
nnoremap <leader>ld <cmd>Telescope lsp_document_symbols<CR>
nnoremap <leader>lw <cmd>Telescope lsp_workspace_symbols<CR>
nnoremap <silent>gr <cmd>Telescope lsp_references<CR>
nnoremap <silent>gi <cmd>Telescope lsp_implementations<CR>
nnoremap <silent>gt <cmd>Telescope lsp_type_definitions<CR>
nnoremap <silent>gd <cmd>Telescope lsp_definitions<CR>
nnoremap <silent>ga <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent>K  <cmd>lua vim.lsp.buf.hover()<CR>
vnoremap <silent>K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>dd <cmd>Telescope diagnostics<CR>
nnoremap <leader>dk <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>dp <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>dj <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>dn <cmd>lua vim.diagnostic.goto_next()<CR>
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes
" window/pane stuff
nnoremap <leader>w- :sp<CR>
nnoremap <leader>w/ :vsp<CR>
nnoremap <leader>w= <C-W>=
nnoremap <leader>wd :q<CR>
nnoremap <leader>wh <C-W>h
nnoremap <leader>wj <C-W>j
nnoremap <leader>wk <C-W>k
nnoremap <leader>wl <C-W>l
nnoremap <leader>wH <C-W>H
nnoremap <leader>wJ <C-W>J
nnoremap <leader>wK <C-W>K
nnoremap <leader>wL <C-W>L
nnoremap <leader>w<CR> <C-W>o
nnoremap <leader><TAB> <C-^>
" tags TODO remove? these are less useful in the face of LSP
"nnoremap <leader>gt :tag <c-r>=expand("<cword>")<CR><CR>
"vnoremap <leader>gt :tag <c-r>=Get_visual_selection()<CR><CR>
"nnoremap <leader>gT :Tag <c-r>=expand("<cword>")<CR><CR>
"vnoremap <leader>gT :Tag <c-r>=Get_visual_selection()<CR><CR>
" comment tools
map <leader>; <plug>NERDCommenterToggle
" toggles
nnoremap <leader>tn :call NumberToggle()<CR>
nnoremap <leader>tc :call ConcealToggle()<cr>
nnoremap <leader>ts :noh<cr>
nnoremap <leader>tg :Goyo<cr>
nnoremap <leader>tl :Limelight!!<cr>
" copy/paste
vmap <leader>y "+y
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P
" easy motion searches
" DO NOT namespace with <Leader>s
" otherwise this will require wait
nmap <Leader>s <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" align tools
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a; :Tabularize /::<CR>
vnoremap <leader>a- :Tabularize /-><CR>
vnoremap <leader>a, :Tabularize /,<CR>
vnoremap <leader>ac :Tabularize /--<CR>
" vimrc
nnoremap <leader>ve :sp ~/.config/nvim/init.vim<cr>
nnoremap <leader>vs :so ~/.config/nvim/init.vim<cr>
"au BufWritePost init.vim so ~/.config/nvim/init.vim


" haskell
augroup haskell_namespace
  au!
  "au FileType haskell nnoremap <leader>ha ms:%!stylish-haskell<CR>'s
  " simformat
  au FileType haskell nnoremap <leader>hf :call Simformat()<CR>
  au FileType haskell vnoremap <leader>hf :!simformat -e<CR>
  " ormolu
  au FileType haskell xnoremap <leader>ho :<c-u>call OrmoluBlock()<CR>
  " hoogle
  au FileType haskell nnoremap <leader>hc :HoogleClose<CR>
  au FileType haskell nnoremap <leader>hh :Hoogle<CR>
  au FileType haskell nnoremap <leader>hi :HoogleInfo<CR>
augroup END
" coq
augroup coq_namespace
  au!
" will be unnecessary after plugin fixed
  au FileType coq nnoremap <silent> <leader>cc :silent! call coquille#Commands() <CR>:CoqLaunch<CR>
  au FileType coq nnoremap <leader>cj :<C-U>call NCoqNext()<CR>
  "au FileType coq nnoremap <leader>cj :CoqNext<CR>
  au FileType coq nnoremap <leader>ck :<C-U>call NCoqUndo()<CR>
  "au FileType coq nnoremap <leader>ck :CoqUndo<CR>
  au FileType coq nnoremap <leader>cz :CoqToCursor<CR>
  au FileType coq nnoremap <leader>cq :CoqStop<CR>
  au FileType coq nnoremap <leader>cx :CoqCancel<CR>
  au FileType coq nnoremap <leader>cv :CoqVersion<CR>
  au FileType coq nnoremap <leader>cb :CoqBuild<CR>
augroup END
" rust
augroup rust_namespace
  au!
  au FileType rust nnoremap <leader>rr :RustRunnables<CR>
  au FileType rust nnoremap <leader>rt :RustTest<CR>
  au FileType rust nnoremap <leader>rT :RustTest!<CR>
  au FileType rust nnoremap <leader>rm :RustExpandMacro<CR>
  au FileType rust nnoremap <leader>rc :RustOpenCargo<CR>
  au FileType rust nnoremap <leader>rp :RustParentModule<CR>
  au FileType rust nnoremap <leader>rd :RustOpenExternalDocs<CR>
  au FileType rust set softtabstop=4
  au FileType rust set shiftwidth=4
augroup END
" java
augroup java_namespace
  au!
  au FileType java set softtabstop=4
  au FileType java set shiftwidth=4
augroup END
" ledger
augroup ledger_namespace
  au!
  au FileType ledger set softtabstop=4
  au FileType ledger set shiftwidth=4
augroup END
