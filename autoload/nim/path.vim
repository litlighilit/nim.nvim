" Routines for resolving file paths

" Expand the filename under the cursor in a folded import, possibly spanning
" lines: ../abc/[fn1, sub2/fn2] resolves sub2/fn2 to ../abc/sub2/fn2.
function! nim#path#IncludeExpr(fname) abort
  " A trailing import separator can be included in 'isfname'.
  " e.g. `,` in `import ./abc/[x,]`
  let filename = substitute(a:fname, ',$', '', '')
  " backword searching for `]` or `[`
  " A closing bracket means the cursor is outside the preceding fold.
  " 'n' keeps the cursor in place; 'W' prevents wrapping around the buffer.
  let [lnum, col] = searchpos('[][]', 'bnW')
  if lnum == 0 || getline(lnum)[col - 1] !=# '['
    return filename
  endif

  " Keep the trailing slash, and stop at whitespace, commas or brackets.
  let prefix = matchstr(strpart(getline(lnum), 0, col - 1), '[^][,[:space:]]\+/$')
  return prefix . filename
endfunction
