let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'
let g:test_count = 0
function! LineColPos(line, col, ...)
  for cmd in a:000
    exec cmd
  endfor
  let g:test_count += 1
  let msg = join(a:000, '|') . '.'
  let l = line('.')
  let c = col('.')
  call vimtap#Is(l, a:line, 'LineColPos Line, Test ' . g:test_count . ': ' . msg)
  call vimtap#Is(c, a:col, 'LineColPos Column, Test ' . g:test_count . ': ' . msg)
endfunction

function! VisualMatch(expected)
  call vimtap#Is(@", a:expected, 'VisualMatch. Test ' . g:test_count)
endfunction

function! LineMatch(line, expected)
  call vimtap#Is(getline(a:line), a:expected, 'LineMatch. Test ' . g:test_count)
endfunction
