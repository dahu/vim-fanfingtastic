let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

function! LineColPos(line, col, ...)
  if a:0
    exec a:1
  endif
  let msg = (a:0 ? ': '.a:1 : '') . '.'
  let l = line('.')
  let c = col('.')
  call vimtap#Is(l, a:line, 'LineColPos Line'.msg)
  call vimtap#Is(c, a:col, 'LineColPos Column'.msg)
endfunction

function! VisualMatch(expected)
  call vimtap#Is(@", a:expected, 'VisualMatch.')
endfunction

function! LineMatch(line, expected)
  call vimtap#Is(getline(a:line), a:expected, 'LineMatch.')
endfunction
