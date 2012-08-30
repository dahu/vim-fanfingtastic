call vimtest#StartTap()
call vimtap#Plan(30) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')

function! s:reset()
  %d
  append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
.
endfunction

" run these tests twice; the first time without f,ing loaded
for loop in range(2)
  call s:reset()
  normal 1G0ctcxyz
  call LineColPos(1, 3)  " <== XXX Account for 2 tests each call XXX
  call LineMatch(1, 'xyzc abc abc abc abc abc')

  call s:reset()
  normal 1G0dtc
  call LineColPos(1, 1)
  call LineMatch(1, 'c abc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  normal 1G0ytc
  call LineColPos(1, 1)
  call VisualMatch('ab')

  call s:reset()
  normal 1G0g~tc
  call LineColPos(1, 1)
  call LineMatch(1, 'ABc abc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  normal 1G0g~2tc
  call LineColPos(1, 1)
  call LineMatch(1, 'ABC ABc abc abc abc abc')  "xyz abc abc...

  %d
  runtime plugin/fanfingtastic.vim
endfor

"normal 1G0v7tcy
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabc")

"normal 1G0vtdy
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd")

"normal 1G0v2tdy
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd")

"normal 1G0vtd;y
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd")

"normal 1G0v2td3;y
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd")

"normal 1G0vtey
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd\nabcde")

call vimtest#Quit()
