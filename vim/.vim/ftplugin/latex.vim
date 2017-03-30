function! ReloadLatex()
  :w
  :!pdflatex %
endfunc
au FileType tex cmap rt call ReloadLatex()


