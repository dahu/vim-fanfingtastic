let b:fchar = ''

" TODO tx does not move beyond the x with succesive tx.
function! s:search(fwd, f, ...)
  " Define what will be searched.
  let pat = a:f ? b:fchar : (a:fwd ? '\_.\ze'.b:fchar : b:fchar.'\zs\_.')
  let b_flag = a:fwd ? '' : 'b'
  " This is for the tx todo.
  let c_flag = !a:0 ? '' : (a:1 && !a:f ? 'c' : '')
  return searchpos('\C\m'.pat, 'W'.b_flag.c_flag)
endfunction

function! s:next_char_pos2(count, f, fwd)
  let cnt = 0
  while cnt < a:count
    let new_pos = s:search(a:fwd, a:f)
    if new_pos[0] == 0
      break
    endif
    " found one
    let cnt += 1
  endwhile
  return new_pos
endfunction

function! s:next_char_pos(count)
  let prev_pos = getpos('.')[1:2]
  let cnt = 0
  while cnt < a:count
    let new_pos = s:search(1, 1)
    if new_pos[0] == 0
      break
    endif
    " found one
    let prev_pos = new_pos
    let cnt += 1
    "break
  endwhile
  return new_pos
endfunction

function! s:set_find_char(args)
  if type(a:args) == type('')
    let b:fchar = empty(a:args) ? nr2char(getchar()) : a:args
  elseif len(a:args) == 2
    let b:fchar = a:args[1]
  else
    let b:fchar = nr2char(getchar())
  endif
endfunction

function! NextChar(count, char, f, fwd)
  let b:ffwd = a:fwd < 0 ? b:ffwd : a:fwd
  let fwd = a:fwd >= 0 ? b:ffwd : (a:fwd == -1 ? b:ffwd : !b:ffwd)
  let b:ff = a:f
  call s:set_find_char(a:char)
  return s:next_char_pos2(a:count, a:f, fwd)
endfunction

function! FindNextChar(args)
  echo a:args
  call s:set_find_char(a:args)
  "call call('s:set_find_char', a:000)
  return s:next_char_pos(a:args[0])
endfunction

function! VisualFindNextChar(args)
  echom string(a:args)
  call s:set_find_char(a:args)
  " this may not work for tT,
  normal! `>
  let new_pos = s:next_char_pos(a:args[0])
  echom 'VFNC new_pos = ' . string(new_pos)
  if new_pos[0] > 0
    call setpos("'`", getpos('.'))
    normal! gv
    normal! ``
  endif
endfunction

function! OperatorFindNextChar(args)
  echom string(a:args)
  call s:set_find_char(a:args)
  if v:operator == 'c'
    exe "normal v" . a:args[0] . "f" . b:fchar . 'x'
  else
    exe "normal v" . a:args[0] . "f" . b:fchar
  endif
endfunction

nnoremap  t :<c-u>call NextChar(v:count1, '', 0, 1)<cr>
nnoremap  T :<c-u>call NextChar(v:count1, '', 0, 0)<cr>
nnoremap  f :<c-u>call NextChar(v:count1, '', 1, 1)<cr>
nnoremap  F :<c-u>call NextChar(v:count1, '', 1, 0)<cr>
nnoremap  , :<c-u>call NextChar(v:count1, b:fchar, b:ff, -2)<cr>
nnoremap  ; :<c-u>call NextChar(v:count1, b:fchar, b:ff, -1)<cr>

vnoremap  f :<c-u>call VisualFindNextChar([v:count1])<cr>
vnoremap  ; :<c-u>call VisualFindNextChar([v:count1, b:fchar])<cr>

onoremap  f :<c-u>call OperatorFindNextChar([v:count1])<cr>
onoremap  ; :<c-u>call OperatorFindNextChar([v:count1, b:fchar])<cr>
