setlocal textwidth=80
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_close_braces = 1
let g:vimtex_env_change_autofill = 1
let g:vimtex_format_enabled = 1
let g:vimtex_quickfix_autoclose_after_keystrokes = 2
let g:Tex_CompileRule_pdf='xelatex --interaction=nonstopmode $*'
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
