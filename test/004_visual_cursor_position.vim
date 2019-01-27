call vimtest#StartTap()
call vimtap#Plan(14) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')

runtime! plugin/fanfingtastic.vim

append
abcd
defg
hijk
.

exec "normal! 2gg0vG$\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,3,5,0], l, 'First case, down.')


exec "normal! G$v2gg0\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,2,1,0], l, 'First case, up.')

exec "normal! gg0v2G$\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,2,5,0], l, 'Second case, down.')

exec "normal! G$vgg0\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,1,1,0], l, 'Second case, up.')

exec "normal! gg2|v$\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,1,5,0], l, 'Third case, up.')

exec "normal! gg2|vG$\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,3,5,0], l, 'Third case, up.')

exec "normal! G$v2|\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,3,2,0], l, 'Third case, down.')

exec "normal! G$vgg2|\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,1,2,0], l, 'Third case, down.')

exec "normal! gg0vG3|\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,3,3,0], l, 'Fourth case, up.')

exec "normal! G3|vgg0\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,1,1,0], l, 'Fourth case, down.')

exec "normal! G$vgg0\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,1,1,0], l, 'Fifth case, left-up.')

exec "normal! gg0vG$\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,3,5,0], l, 'Fifth case, right-down.')

exec "normal! gg$vG0\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,3,1,0], l, 'Fifth case, right-up.')

exec "normal! G0vgg$\<Esc>"
let l = FanfingtasticEval('s:get_visual_pos()')
call vimtap#Is(l, [0,1,5,0], l, 'Fifth case, left-down.')

call vimtest#Quit()

