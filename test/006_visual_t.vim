call vimtest#StartTap()
call vimtap#Plan(78) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc abc abc abc abc
abcd abcd abcd abcd abcd
abcde
a line with ~ and * here
another line with ~ and * here
.

" run these tests twice; the first time without f,ing loaded
for loop in range(2)

  call LineColPos(1, 1, 'normal 1G0vtcy')  " <== XXX Account for 2 tests each call XXX
  call VisualMatch('ab')

  call LineColPos(1, 2, 'normal 1G0tcv2tcy')
  call VisualMatch('bc ab')

  call LineColPos(1, 2, 'normal 1G0tcv2tc;y')
  call VisualMatch('bc abc ab')

  if &selection == 'inclusive'
    call LineColPos(1, 2, 'normal 1G0tcv2tc2;y')
    call VisualMatch('bc abc ab')
  elseif &selection == 'exclusive'
    call LineColPos(1, 2, 'normal 1G0tcv2tc2;y')
    call VisualMatch('bc abc abc ab')
  endif

  runtime plugin/fanfingtastic.vim
endfor

call LineColPos(1, 1, 'normal 1G0v7tcy')
call VisualMatch("abc abc abc abc abc abc\nab")

call LineColPos(1, 1, 'normal 1G0vtdy')
call VisualMatch("abc abc abc abc abc abc\nabc")

call LineColPos(1, 1, 'normal 1G0v2tdy')
call VisualMatch("abc abc abc abc abc abc\nabcd abc")

call LineColPos(1, 1, 'normal 1G0vtd;y')
call VisualMatch("abc abc abc abc abc abc\nabcd abc")

call LineColPos(1, 1, 'normal 1G0vtey')
call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abcd\nabcd")

call LineColPos(4, 1, 'normal 4G0vt*y')
call VisualMatch("a line with ~ and ")

call LineColPos(4, 1, 'normal 4G0vt*;y')
call VisualMatch("a line with ~ and * here\nanother line with ~ and ")

call LineColPos(4, 1, 'normal 4G0v2t*y')
call VisualMatch("a line with ~ and * here\nanother line with ~ and ")

call LineColPos(4, 1, 'normal 4G0vt~y')
call VisualMatch("a line with ")

call LineColPos(4, 1, 'normal 4G0vt~;y')
call VisualMatch("a line with ~ and * here\nanother line with ")

call LineColPos(4, 1, 'normal 4G0v2t~y')
call VisualMatch("a line with ~ and * here\nanother line with ")

if &selection == 'inclusive'

  call LineColPos(1, 1, 'normal 1G0v2td3;y')
  call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abc")

  call LineColPos(5, 26, 'normal 5G$vT*y')
  call VisualMatch(" here")

  call LineColPos(4, 20, 'normal 5G$vT*;y')
  call VisualMatch(" here\nanother line with ~ and * here")

  call LineColPos(4, 20, 'normal 5G$v2T*y')
  call VisualMatch(" here\nanother line with ~ and * here")

  call LineColPos(5, 20, 'normal 5G$vT~y')
  call VisualMatch(" and * here")

  call LineColPos(4, 14, 'normal 5G$vT~;y')
  call VisualMatch(" and * here\nanother line with ~ and * here")

  call LineColPos(4, 14, 'normal 5G$2T~')
  call VisualMatch(" and * here\nanother line with ~ and * here")

elseif &selection == 'exclusive'

  call LineColPos(1, 1, 'normal 1G0v2td3;y')
  call VisualMatch("abc abc abc abc abc abc\nabcd abcd abcd abcd abc")

  call LineColPos(5, 26, 'normal 5G$vT*y')
  call VisualMatch(" her")

  call LineColPos(4, 20, 'normal 5G$vT*;y')
  call VisualMatch(" here\nanother line with ~ and * her")

  call LineColPos(4, 20, 'normal 5G$v2T*y')
  call VisualMatch(" here\nanother line with ~ and * her")

  call LineColPos(5, 20, 'normal 5G$vT~y')
  call VisualMatch(" and * her")

  call LineColPos(4, 14, 'normal 5G$vT~;y')
  call VisualMatch(" and * here\nanother line with ~ and * her")

  call LineColPos(4, 14, 'normal 5G$2T~')
  call VisualMatch(" and * here\nanother line with ~ and * her")

endif

call vimtest#Quit()
