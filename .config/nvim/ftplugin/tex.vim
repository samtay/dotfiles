setlocal textwidth=80
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_close_braces = 1
let g:vimtex_env_change_autofill = 1
let g:vimtex_format_enabled = 1
let g:vimtex_quickfix_autoclose_after_keystrokes = 2
let g:vimtex_compiler_latexmk = {
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \   '--enable-write18',
      \ ]
      \}
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : '-1',
  \ 'rhs' : '^{-1}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : 'Z',
  \ 'rhs' : '\mathbb{Z}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : 'N',
  \ 'rhs' : '\mathbb{N}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : 'R',
  \ 'rhs' : '\mathbb{R}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : '0',
  \ 'rhs' : '\varnothing',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : 'T',
  \ 'rhs' : '\mathcal{T}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : 'B',
  \ 'rhs' : '\mathcal{B}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
call vimtex#imaps#add_map(
  \{
  \ 'lhs' : 'm',
  \ 'rhs' : '\mathcal{}',
  \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
  \})
" Use deoplete / snippets.
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/git/vim-snippets/snippets'
let g:python_host_prog='/usr/bin/python3' " fix virtualenv's
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
nmap <leader>ll <plug>(vimtex-view)
