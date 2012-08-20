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

function! s:next_char_pos(occurrence)
  let prev_pos = getpos('.')[1:2]
  let cnt = 0
  while cnt < a:occurrence
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
  if len(a:args) == 2
    let b:fchar = a:args[1]
  else
    let b:fchar = nr2char(getchar())
  endif
endfunction

function! FindNextChar(args)
  echo a:args
  call s:set_find_char(a:args)
  "call call('s:set_find_char', a:000)
  return s:next_char_pos(a:args[0])
endfunction

function! VisualFindNextChar(args)
  echo a:args
  call s:set_find_char(a:args)
  let new_pos = s:next_char_pos(a:args[0])
  echo new_pos
  if new_pos[0] > 0
    call setpos("'`", getpos('.'))
    normal! gv
    normal! ``
  endif
endfunction

function! OperatorFindNextChar(args)
  echo a:args
  call s:set_find_char(a:args)
  let cur_pos = getpos('.')
  let new_pos = s:next_char_pos(a:args[0])
  echom "operator=#" . v:operator . "#"
  if cur_pos != new_pos
    if v:operator == 'c'
      exe "normal v" . a:args[0] . "f" . b:fchar . 'x'
      startinsert
    else
      exe "normal v" . a:args[0] . "f" . b:fchar . v:operator
    endif
  endif
endfunction

nnoremap  f :<c-u>call FindNextChar([v:count1])<cr>
nnoremap  ; :<c-u>call FindNextChar([v:count1, b:fchar])<cr>

vnoremap  f :<c-u>call VisualFindNextChar([v:count1])<cr>
vnoremap  ; :<c-u>call VisualFindNextChar([v:count1, b:fchar])<cr>

onoremap  f :<c-u>call OperatorFindNextChar([v:count1])<cr>
onoremap  ; :<c-u>call OperatorFindNextChar([v:count1, b:fchar])<cr>
