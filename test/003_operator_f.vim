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
  normal 1G0cfcxyz
  call LineColPos(1, 3)  " <== XXX Account for 2 tests each call XXX
  call LineMatch(1, 'xyz abc abc abc abc abc')

  call s:reset()
  normal 1G0dfc
  call LineColPos(1, 1)
  call LineMatch(1, ' abc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  normal 1G0yfc
  call LineColPos(1, 1)
  call VisualMatch('abc')

  call s:reset()
  normal 1G0g~fc
  call LineColPos(1, 1)
  call LineMatch(1, 'ABC abc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  normal 1G0g~2fc
  call LineColPos(1, 1)
  call LineMatch(1, 'ABC ABC abc abc abc abc')  "xyz abc abc...

  %d
  runtime plugin/fanfingtastic.vim
endfor

"normal 1G0v7fcy
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabc")

"normal 1G0vfdy
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd")

"normal 1G0v2fdy
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd")

"normal 1G0vfd;y
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd")

"normal 1G0v2fd3;y
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd")

"normal 1G0vfey
"call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
"call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd\nabcde")

call vimtest#Quit()
