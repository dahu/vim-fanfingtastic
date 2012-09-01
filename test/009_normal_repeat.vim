call vimtest#StartTap()
call vimtap#Plan(4) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
a line with ~ and * here
another line with ~ and * here
.

runtime plugin/fanfingtastic.vim

" Do nothing on ;/, before using f/F/t/T.
call LineColPos(1, 23, 'normal 1G0;$') " <== XXX Account tor 2 tests each call XXX

call LineColPos(1, 1, 'normal 1G$,0')

call vimtest#Quit()
