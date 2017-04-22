function! ReloadLatex()
  :w
  :!pdflatex %
endfunc
nmap <leader><Enter> :call ReloadLatex()<CR>
