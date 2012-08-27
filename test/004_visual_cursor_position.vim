call vimtest#StartTap()
call vimtap#Plan(12) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
ru plugin/fanfingtastic.vim
call setline(1, ['abcd', 'defg', 'hijk'])

exec "normal! v\<Esc>"
exec "normal! 2gg0vG$\<Esc>"
call vimtap#Is(GetVisualPos(), [0,3,5,0], 'First case, down.')
exec "normal! v\<Esc>"
exec "normal! G$v2gg0\<Esc>"
call vimtap#Is(GetVisualPos(), [0,2,1,0], 'First case, up.')
exec "normal! v\<Esc>"
exec "normal! gg0v2G$\<Esc>"
call vimtap#Is(GetVisualPos(), [0,2,5,0], 'Second case, down.')
exec "normal! v\<Esc>"
exec "normal! G$vgg0\<Esc>"
call vimtap#Is(GetVisualPos(), [0,1,1,0], 'Second case, up.')
exec "normal! v\<Esc>"
exec "normal! gg2|vG$\<Esc>"
call vimtap#Is(GetVisualPos(), [0,3,5,0], 'Third case, up.')
exec "normal! v\<Esc>"
exec "normal! G$vgg2|\<Esc>"
call vimtap#Is(GetVisualPos(), [0,1,2,0], 'Third case, down.')
exec "normal! v\<Esc>"
exec "normal! gg0vG3|\<Esc>"
call vimtap#Is(GetVisualPos(), [0,3,3,0], 'Fourth case, up.')
exec "normal! v\<Esc>"
exec "normal! G3|vgg0\<Esc>"
call vimtap#Is(GetVisualPos(), [0,1,1,0], 'Fourth case, down.')
exec "normal! v\<Esc>"
exec "normal! G$vgg0\<Esc>"
call vimtap#Is(GetVisualPos(), [0,1,1,0], 'Fifth case, left-up.')
exec "normal! v\<Esc>"
exec "normal! gg0vG$\<Esc>"
call vimtap#Is(GetVisualPos(), [0,3,5,0], 'Fifth case, right-down.')
exec "normal! v\<Esc>"
exec "normal! gg$vG0\<Esc>"
call vimtap#Is(GetVisualPos(), [0,3,1,0], 'Fifth case, right-up.')
exec "normal! v\<Esc>"
exec "normal! G0vgg$\<Esc>"
call vimtap#Is(GetVisualPos(), [0,1,5,0], 'Fifth case, left-down.')

call vimtest#Quit()

