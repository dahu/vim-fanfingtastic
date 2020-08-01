call vimtest#StartTap()
call vimtap#Plan(6) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')

runtime! plugin/fanfingtastic.vim

append
Issue 21 report text:

If you have a single line selected,
f will go to the first match it can find, unless there is a match on the current line,
in which case it always goes to the match closest to the beginning of the line, regardless of cursor position
F always goes to the last occurrence in the lines above the current, ignoring matches on the current line

If you have multiple lines selected and the line you have selected is the top line of your selection,
f will go to the first match it can find, unless there is a match on the current line,
in which case it always goes to the match closest to the beginning of the line, regardless of current cursor position
F always goes to the last occurrence in the lines above the current, ignoring matches on the current line

If you have multiple lines selected and the line you have selected is the bottom line of your selection,
f always goes to the first occurrence in the lines below the current, ignoring matches on the current line
F will go to the first match it can find, unless there is a match in the current line,
in which case it always goes to the match closest to the end of the line, regardless of cursor position
.

exec "normal 4gg20|Vft\<Esc>"
let l = getpos('.')
call vimtap#Is(l, [0,4,22,0], l, 'single line selected f')

exec "normal 6gg20|VFg\<Esc>"
let l = getpos('.')
call vimtap#Is(l, [0,6,10,0], l, 'single line selected F')

exec "normal 9gg20|Vkfy\<Esc>"
let l = getpos('.')
call vimtap#Is(l, [0,8,50,0], l, 'multi line top selected f')

exec "normal 11gg20|VkFc\<Esc>"
let l = getpos('.')
call vimtap#Is(l, [0,10,10,0], l, 'multi line top selected F')

exec "normal 13gg20|Vjfo\<Esc>"
let l = getpos('.')
call vimtap#Is(l, [0,14,28,0], l, 'multi line bottom selected f')

exec "normal 16gg20|VkFg;\<Esc>"
let l = getpos('.')
call vimtap#Is(l, [0,14,78,0], l, 'multi line bottom selected F')


call vimtest#Quit()

