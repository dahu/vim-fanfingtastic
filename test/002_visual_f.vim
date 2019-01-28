call vimtest#StartTap()
call vimtap#Plan(49) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
one two three four five six
.

" run these tests twice; the first time without f,ing loaded
for loop in range(2)

  normal 1G0vfcy
  call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
  call VisualMatch('abc')

  normal 1G0fcv2fcy
  call LineColPos(1, 3)
  call VisualMatch('c abc abc')

  normal 1G0fcv2fc;y
  call LineColPos(1, 3)
  call VisualMatch('c abc abc abc')

  normal 1G0fcv2fc2;y
  call LineColPos(1, 3)
  call VisualMatch('c abc abc abc abc')

  " NOTE: This test fails with &selection='exclusive' because of
  " Vim's internal handling of EOL in that mode unless &virtualedit is also set.
  " Read :help 'selection
  normal 4G$hviwoF ;y
  call LineColPos(4, 19)
  call VisualMatch(' five six')

  runtime plugin/fanfingtastic.vim
endfor

normal 1G0v7fcy
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabc")

normal 1G0vfdy
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd")

normal 1G0v2fdy
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abcd")

normal 1G0vfd;y
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abcd")

normal 1G0v2fd3;y
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd")

normal 1G0vfey
call LineColPos(1, 1)  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd\nabcde")

%d
append
some text
some text
some text
.
exec "normal gg0\<C-V>2jf sfoo\<ESC>"
let expected = getline(1, '$')
call vimtap#Is(expected, ['footext', 'footext', 'footext'], expected, 'Preserve visual mode.')

call vimtest#Quit()
