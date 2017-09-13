function! ReloadLatex()
  :w
  :!xelatex %
endfunc
nmap <leader><Enter> :call ReloadLatex()<CR>
