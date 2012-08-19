let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

runtime plugin/fanfingtastic.vim

function! LineColPos(line, col)
  let l = line('.')
  let c = col('.')
  call vimtap#Ok(l == a:line, 'LineColPos Line ' . a:line . ' expected, got ' . l)
  call vimtap#Ok(c == a:col, 'LineColPos Column ' . a:col . ' expected, got ' . c)
endfunction
