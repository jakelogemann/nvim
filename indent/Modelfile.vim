if exists('b:did_indent') | finish | endif
let b:did_indent = 1


function! ModelfileIndent(line)
  let prev_line = getline(a:line - 1)
  if a:line > 1 && prev_line =~ '\\\s*$'
    let i = indent(a:line - 1)
    if i == 0
      let i += &l:shiftwidth
      if &l:expandtab && prev_line =~# '^RUN\s'
        " Overindent past RUN
        let i = 4 + &l:shiftwidth
      endif
    endif
    return i
  endif

  return -1
endfunction


set indentexpr=ModelfileIndent(v:lnum)
