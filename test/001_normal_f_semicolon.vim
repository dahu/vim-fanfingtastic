call vimtest#StartTap()
call vimtap#Plan(128) " <== XXX  Keep plan number updated.  XXX
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

  " t {{{1
  call LineColPos(1, 2, 'normal 1G0tc')  " <== XXX Account tor 4 tests each call XXX

  call LineColPos(1, 6, 'normal 1G02tc')

  call LineColPos(1, 10, 'normal 1G03tc')

  call vimtap#Todo(2) " TODO This hasn't been implemented yet. Not sure it should.
  call LineColPos(1, 3, 'normal 1G0tctc')

  call LineColPos(1, 6, 'normal 1G0tc;')

  call LineColPos(1, 10, 'normal 1G0tc2;')

  call LineColPos(1, 18, 'normal 1G02tc3;')

  call LineColPos(1, 20, 'normal 1G20|tc,')

  call LineColPos(1, 16, 'normal 1G20|tc2,')

  call LineColPos(1, 12, 'normal 1G16|2tc3,')

  " T {{{1
  call LineColPos(1, 22, 'normal 1G$Ta')

  call LineColPos(1, 18, 'normal 1G$2Ta')

  call LineColPos(1, 14, 'normal 1G$3Ta')

  call LineColPos(1, 18, 'normal 1G$TaTa')

  call LineColPos(1, 18, 'normal 1G$Ta;')

  call LineColPos(1, 14, 'normal 1G$Ta2;')

  call LineColPos(1, 6, 'normal 1G$2Ta3;')

  call LineColPos(1, 4, 'normal 1G4|Ta,')

  call LineColPos(1, 8, 'normal 1G4|Ta2,')

  call LineColPos(1, 12, 'normal 1G8|2Ta3,')

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
