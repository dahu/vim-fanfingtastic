call vimtest#StartTap()
call vimtap#Plan(78) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')

let &runtimepath = '$HOME/.vim/bundle/vendor/vim-repeat' . &rtp
runtime! autoload/repeat.vim

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
return
1) abc abc abc abc abc abc
2) abcd abcd abcd abcd abcd
3) abcde
4) type == assigned
5) type == assigned
6) type == assigned
7) type == assigned
8) let somevar -= 1000
9) let somevar -= 1000
endfunction

" run these tests twice; the first time without f,ing loaded
for loop in range(2)
  " "doautocmd CursorHold" is needed to trigger repeat's magic.
  " XXX Don't forget to prepend vim-repeat path to the rtp in your global
  " runVimTestsSetup.vim.
  call s:reset()
  call LineColPos(1, 3, 'normal 1G0ctcxyz')  " <== XXX Account for 2 tests each call XXX
  call LineMatch(1, 'xyzc abc abc abc abc abc')

  call s:reset()
  call LineColPos(1, 1, 'normal 1G0dtc')
  call LineMatch(1, 'c abc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  call LineColPos(1, 1, 'normal 1G0ytc')
  call VisualMatch('ab')

  call s:reset()
  call LineColPos(1, 1, 'normal 1G0g~tc')
  call LineMatch(1, 'ABc abc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  call LineColPos(1, 1, 'normal 1G0g~2tc')
  call LineMatch(1, 'ABC ABc abc abc abc abc')  "xyz abc abc...

  call s:reset()
  call LineColPos(4, 1, 'normal 4G0df ma', 'doautocmd CursorMoved', 'normal `a.')
  call LineMatch(4, 'assigned')

  call s:reset()
  call LineColPos(5, 5, 'normal 5G$dF ma', 'doautocmd CursorMoved', 'normal `a.')
  call LineMatch(5, 'typed')

  call s:reset()
  call LineColPos(6, 1, 'normal 6G0dt ma', 'doautocmd CursorMoved', 'normal `a.')
  call LineMatch(6, ' assigned')

  " dT
  call s:reset()
  call LineColPos(7, 6, 'normal 7G$dT hma', 'doautocmd CursorMoved', 'normal `a.')
  call LineMatch(7, 'type  d')

  " d;.
  call s:reset()
  call LineColPos(8, 1, 'normal 8G0df d;ma', 'doautocmd CursorMoved', 'normal `a.')
  call LineMatch(8, '1000')

  call s:reset()
  call LineColPos(1, 15, 'normal 1G05fcgU,')
  call LineMatch(1, 'abc abc abc abC ABc abc')

  call s:reset()
  call LineColPos(1, 11, 'normal 1G05fcgU,ma', 'doautocmd CursorMoved', 'normal `a.')
  call LineMatch(1, 'abc abc abC ABC ABc abc')

  " d,.
  call s:reset()
  call LineColPos(9, 4, 'normal 9G$bbdf ma', 'silent! doautocmd CursorMoved', 'normal `ad,ma', 'silent! doautocmd CursorMoved', 'normal `a.')
  call LineMatch(9, 'let1000')

  %d
  runtime plugin/fanfingtastic.vim
endfor


call vimtest#Quit()
