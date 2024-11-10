" vint: -ProhibitAutocmdWithNoGroup

" Dockerfile
autocmd BufRead,BufNewFile [Mm]odelfile set ft=Modelfile
autocmd BufRead,BufNewFile [Mm]odelfile* setfiletype Modelfile
autocmd BufRead,BufNewFile *.[Mm]odelfile set ft=Modelfile
autocmd BufRead,BufNewFile [Mm]odelfile.vim set ft=vim

