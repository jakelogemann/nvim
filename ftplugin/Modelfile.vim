" Define comment string
setlocal commentstring=#\ %s

" Enable automatic comment insertion
setlocal formatoptions+=cro

function! ModelfileReplaceInstruction(original, replacement)
    let syn = synIDtrans(synID(line("."), col(".") - 1, 0))
    if syn != hlID("Comment") && syn != hlID("Constant") && strlen(getline(".")) == 0
        let word = a:replacement
    else
        let word = a:original
    endif
    let g:UnduBuffer = a:original
    return word
endfunction

inoreabbr <silent> <buffer> from <C-R>=ModelfileReplaceInstruction("from", "FROM")<CR>
inoreabbr <silent> <buffer> maintainer <C-R>=ModelfileReplaceInstruction("maintainer", "MAINTAINER")<CR>
inoreabbr <silent> <buffer> parameter <C-R>=ModelfileReplaceInstruction("parameter", "PARAMETER")<CR>
inoreabbr <silent> <buffer> cmd <C-R>=ModelfileReplaceInstruction("cmd", "CMD")<CR>
inoreabbr <silent> <buffer> label <C-R>=ModelfileReplaceInstruction("label", "LABEL")<CR>
inoreabbr <silent> <buffer> expose <C-R>=ModelfileReplaceInstruction("expose", "EXPOSE")<CR>
inoreabbr <silent> <buffer> env <C-R>=ModelfileReplaceInstruction("env", "ENV")<CR>
inoreabbr <silent> <buffer> add <C-R>=ModelfileReplaceInstruction("add", "ADD")<CR>
inoreabbr <silent> <buffer> copy <C-R>=ModelfileReplaceInstruction("copy", "COPY")<CR>
inoreabbr <silent> <buffer> entrypoint <C-R>=ModelfileReplaceInstruction("entrypoint", "ENTRYPOINT")<CR>
inoreabbr <silent> <buffer> volume <C-R>=ModelfileReplaceInstruction("volume", "VOLUME")<CR>
inoreabbr <silent> <buffer> user <C-R>=ModelfileReplaceInstruction("user", "USER")<CR>
inoreabbr <silent> <buffer> workdir <C-R>=ModelfileReplaceInstruction("workdir", "WORKDIR")<CR>
inoreabbr <silent> <buffer> arg <C-R>=ModelfileReplaceInstruction("arg", "ARG")<CR>
inoreabbr <silent> <buffer> onbuild <C-R>=ModelfileReplaceInstruction("onbuild", "ONBUILD")<CR>
inoreabbr <silent> <buffer> stopsignal <C-R>=ModelfileReplaceInstruction("stopsignal", "STOPSIGNAL")<CR>
