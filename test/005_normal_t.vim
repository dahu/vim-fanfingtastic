call vimtest#StartTap()
call vimtap#Plan(132) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
a line with ~ and * here
another line with ~ and * here
one char change
.

" run these tests twice; the first time without f,ing loaded
for loop in range(2)
  " t {{{1
  call LineColPos(1, 2, 'normal 1G0tc')  " <== XXX Account tor 4 tests each call XXX

  call LineColPos(1, 6, 'normal 1G02tc')

  call LineColPos(1, 10, 'normal 1G03tc')

  call LineColPos(1, 2, 'normal 1G0tctc')

  call LineColPos(1, 6, 'normal 1G0tc;')

  call LineColPos(1, 6, 'normal 1G0tc2;')

  call LineColPos(1, 14, 'normal 1G02tc3;')

  call LineColPos(1, 20, 'normal 1G20|tc,')

  call LineColPos(1, 16, 'normal 1G20|tc2,')

  call LineColPos(1, 12, 'normal 1G16|2tc3,')

  " T {{{1
  call LineColPos(1, 22, 'normal 1G$Ta')

  call LineColPos(1, 18, 'normal 1G$2Ta')

  call LineColPos(1, 14, 'normal 1G$3Ta')

  call LineColPos(1, 22, 'normal 1G$TaTa')

  call LineColPos(1, 18, 'normal 1G$Ta;')

  call LineColPos(1, 18, 'normal 1G$Ta2;')

  call LineColPos(1, 10, 'normal 1G$2Ta3;')

  call LineColPos(1, 4, 'normal 1G4|Ta,')

  call LineColPos(1, 8, 'normal 1G4|Ta2,')

  call LineColPos(1, 12, 'normal 1G8|2Ta3,')

  call LineColPos(6, 3, 'normal 6G3|ct a')
  call LineMatch(6, 'ona char change')

  runtime plugin/fanfingtastic.vim
endfor

" f,ing only tests from here down {{{1

call LineColPos(2, 2, 'normal 1G07tc')

call LineColPos(2, 3, 'normal 1G0td')

call LineColPos(2, 8, 'normal 1G02td')

call LineColPos(2, 13, 'normal 1G03td')

call LineColPos(2, 8, 'normal 1G0td;')

call LineColPos(2, 8, 'normal 1G0td2;')

call LineColPos(2, 18, 'normal 1G02td3;')

call LineColPos(2, 8, 'normal 1G0td;')

call LineColPos(2, 8, 'normal 1G0td2;')

call LineColPos(2, 18, 'normal 1G02td3;')

call LineColPos(3, 4, 'normal 1G0te')

call LineColPos(4, 18, 'normal 1G0t*')
call LineColPos(5, 24, 'normal 1G0t*;')
call LineColPos(5, 24, 'normal 1G02t*')

call LineColPos(4, 12, 'normal 1G0t~')
call LineColPos(5, 18, 'normal 1G0t~;')
call LineColPos(5, 18, 'normal 1G02t~')

call LineColPos(5, 26, 'normal 5G$T*')
call LineColPos(4, 20, 'normal 5G$T*;')
call LineColPos(4, 20, 'normal 5G$2T*')

call LineColPos(5, 20, 'normal 5G$T~')
call LineColPos(4, 14, 'normal 5G$T~;')
call LineColPos(4, 14, 'normal 5G$2T~')

call vimtest#Quit()

