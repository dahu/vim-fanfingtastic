call vimtest#StartTap()
call vimtap#Plan(42) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
.

" run these tests twice; the first time without f,ing loaded
for loop in range(2)

  normal 1G0vtcy
  call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
  call VisualMatch('ab')

  normal 1G0tcv2tcy
  call LineColPos(1, 2)
  call VisualMatch('bc ab')

  normal 1G0tcv2tc;y
  call LineColPos(1, 2)
  call VisualMatch('bc abc ab')

  normal 1G0tcv2tc2;y
  call LineColPos(1, 2)
  call VisualMatch('bc abc ab')

  runtime plugin/fanfingtastic.vim
endfor

normal 1G0v7tcy
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nab")

normal 1G0vtdy
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabc")

normal 1G0v2tdy
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abc")

normal 1G0vtd;y
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abc")

normal 1G0v2td3;y
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abc")

normal 1G0vtey
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd\nabcd")

call vimtest#Quit()
