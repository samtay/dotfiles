setlocal tabstop=2
setlocal shiftwidth=2

" ale
let g:ale_completion_enabled = 1
let b:ale_linters = ['brittany', 'hlint', 'stack-build']
" Write this in your vimrc file
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0

" align tools
let g:haskell_tabular = 0
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a; :Tabularize /::<CR>
vnoremap <leader>a- :Tabularize /-><CR>
vnoremap <leader>a, :Tabularize /,<CR>
vnoremap <leader>ac :Tabularize /--<CR>
" formatting
let g:brittany_on_save = 0
let g:brittany_config_file = "~/.config/brittany/config.yaml"
vnoremap <leader>asb :Brittany<CR>
nnoremap <leader>asb :Brittany<CR>
nnoremap <leader>ase :DeleteTrailingWS<CR>

" ghcid !
nnoremap <leader>hgl :Ghcid -c 'stack ghci learning-server:lib'<CR>
nnoremap <leader>hgt :Ghcid -c 'stack ghci --main-is apitest:exe:run-academy-integration-tests apitest:lib'<CR>
nnoremap <leader>hgd :GhcidKill<CR>

" hoogle
nnoremap <leader>hh :Hoogle<CR>
nnoremap <leader>hi :HoogleInfo<CR>
nnoremap <leader>hc :HoogleClose<CR>

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
"autocmd FileType * 
      "\if &omnifunc != '' |
      "\call SuperTabChain(&omnifunc, "<c-p>") |
      "\call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
      "\endif

