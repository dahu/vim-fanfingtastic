call vimtest#StartTap()
call vimtap#Plan(40) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
.

" run these tests twice; the first time without f,ing loaded
for loop in range(2)

  normal 1G0fc
  call LineColPos(1, 3)  " <== XXX Account for 2 tests each call XXX

  normal 1G02fc
  call LineColPos(1, 7)

  normal 1G03fc
  call LineColPos(1, 11)

  normal 1G0fc;
  call LineColPos(1, 7)

  normal 1G0fc2;
  call LineColPos(1, 11)

  normal 1G02fc3;
  call LineColPos(1, 19)

  runtime plugin/fanfingtastic.vim
endfor

" f,ing only tests from here down

normal 1G07fc
call LineColPos(2, 3)

normal 1G0fd
call LineColPos(2, 4)

normal 1G02fd
call LineColPos(2, 9)

normal 1G03fd
call LineColPos(2, 14)

normal 1G0fd;
call LineColPos(2, 9)

normal 1G0fd2;
call LineColPos(2, 14)

normal 1G02fd3;
call LineColPos(2, 24)

normal 1G0fe
call LineColPos(3, 5)

call vimtest#Quit()
