call vimtest#StartTap()
call vimtap#Plan(14) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
ru plugin/fanfingtastic.vim
append
abcd
defg
hijk
.

exec "normal! 2gg0vG$\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,3,5,0], 'First case, down.')
exec "normal! G$v2gg0\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,2,1,0], 'First case, up.')
exec "normal! gg0v2G$\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,2,5,0], 'Second case, down.')
exec "normal! G$vgg0\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,1,1,0], 'Second case, up.')
exec "normal! gg2|v$\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,1,5,0], 'Third case, up.')
exec "normal! gg2|vG$\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,3,5,0], 'Third case, up.')
exec "normal! G$v2|\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,3,2,0], 'Third case, down.')
exec "normal! G$vgg2|\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,1,2,0], 'Third case, down.')
exec "normal! gg0vG3|\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,3,3,0], 'Fourth case, up.')
exec "normal! G3|vgg0\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,1,1,0], 'Fourth case, down.')
exec "normal! G$vgg0\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,1,1,0], 'Fifth case, left-up.')
exec "normal! gg0vG$\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,3,5,0], 'Fifth case, right-down.')
exec "normal! gg$vG0\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,3,1,0], 'Fifth case, right-up.')
exec "normal! G0vgg$\<Esc>"
call vimtap#Is(FanfingtasticEval('s:get_visual_pos()'), [0,1,5,0], 'Fifth case, left-down.')

call vimtest#Quit()

