let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

function! LineColPos(line, col)
  let l = line('.')
  let c = col('.')
  call vimtap#Is(l, a:line, 'LineColPos Line.')
  call vimtap#Is(c, a:col, 'LineColPos Column.')
endfunction

function! VisualMatch(expected)
  call vimtap#Is(@", a:expected, 'VisualMatch.')
endfunction

function! LineMatch(line, expected)
  call vimtap#Is(getline(a:line), a:expected, 'LineMatch.')
endfunction
