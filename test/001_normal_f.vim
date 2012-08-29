call vimtest#StartTap()
call vimtap#Plan(94) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
.

" run these tests twice; the first time without f,ing loaded
for loop in range(2)
  " f {{{1
  call LineColPos(1, 3, 'normal 1G0fc')  " <== XXX Account for 4 tests each call XXX

  call LineColPos(1, 7, 'normal 1G02fc')

  call LineColPos(1, 11, 'normal 1G03fc')

  call LineColPos(1, 7, 'normal 1G0fc;')

  call LineColPos(1, 11, 'normal 1G0fc2;')

  call LineColPos(1, 19, 'normal 1G02fc3;')

  call LineColPos(1, 19, 'normal 1G20|fc,')

  call LineColPos(1, 15, 'normal 1G20|fc2,')

  call LineColPos(1, 11, 'normal 1G16|2fc3,')

  " F {{{1
  call LineColPos(1, 21, 'normal 1G$Fa')

  call LineColPos(1, 17, 'normal 1G$2Fa')

  call LineColPos(1, 13, 'normal 1G$3Fa')

  call LineColPos(1, 17, 'normal 1G$Fa;')

  call LineColPos(1, 13, 'normal 1G$Fa2;')

  call LineColPos(1, 5, 'normal 1G$2Fa3;')

  call LineColPos(1, 5, 'normal 1G4|Fa,')

  call LineColPos(1, 9, 'normal 1G4|Fa2,')

  call LineColPos(1, 13, 'normal 1G8|2Fa3,')

  runtime plugin/fanfingtastic.vim
endfor

" f,ing only tests from here down {{{1

call LineColPos(2, 3, 'normal 1G07fc')

call LineColPos(2, 4, 'normal 1G0fd')

call LineColPos(2, 9, 'normal 1G02fd')

call LineColPos(2, 14, 'normal 1G03fd')

call LineColPos(2, 9, 'normal 1G0fd;')

call LineColPos(2, 14, 'normal 1G0fd2;')

call LineColPos(2, 24, 'normal 1G02fd3;')

call LineColPos(2, 9, 'normal 1G0fd;')

call LineColPos(2, 14, 'normal 1G0fd2;')

call LineColPos(2, 24, 'normal 1G02fd3;')

call LineColPos(3, 5, 'normal 1G0fe')

call vimtest#Quit()
