let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

call pathogen#infect('bundle/test/{}')

" Test this plugin with both &selection==inclusive (default) and &selection==exclusive
" set selection=exclusive

let g:test_count = 0
function! LineColPos(line, col, ...)
  for cmd in a:000
    exec cmd
  endfor
  let g:test_count += 1
  let msg = join(a:000, '|') . '.'
  let l = line('.')
  let c = col('.')
  call vimtap#Is(l, a:line, l, 'LineColPos Line, Test ' . g:test_count . ': ' . msg)
  call vimtap#Is(c, a:col, c, 'LineColPos Column, Test ' . g:test_count . ': ' . msg)
endfunction

function! VisualMatch(expected)
  call vimtap#Is(@", a:expected, @", 'VisualMatch. Test ' . g:test_count)
endfunction

function! LineMatch(line, expected)
  let line = getline(a:line)
  call vimtap#Is(line, a:expected, line, 'LineMatch. Test ' . g:test_count)
endfunction
