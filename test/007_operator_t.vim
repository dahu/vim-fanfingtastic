call vimtest#StartTap()
call vimtap#Plan(66) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')

function! s:reset()
  %d
  append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
type == assigned
type == assigned
type == assigned
type == assigned
let somevar -= 1000
let somevar -= 1000
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

  call s:reset()
  normal 4G0df .
  call LineColPos(4, 1)
  call LineMatch(4, 'assigned')

  call s:reset()
  normal 5G$dF .
  call LineColPos(5, 5)
  call LineMatch(5, 'typed')

  call s:reset()
  normal 6G0dt .
  call LineColPos(6, 1)
  call LineMatch(6, ' assigned')

  " dT
  call s:reset()
  normal 7G$dT h.
  call LineColPos(7, 6)
  call LineMatch(7, 'type  d')

  " d;.
  call s:reset()
  normal 8G0df d;.
  call LineColPos(8, 1)
  call LineMatch(8, '1000')

  " d,.
  call s:reset()
  normal 9G$bbdf d,.
  call LineColPos(9, 4)
  call LineMatch(9, 'let1000')

  %d
  runtime plugin/fanfingtastic.vim
endfor


call vimtest#Quit()
