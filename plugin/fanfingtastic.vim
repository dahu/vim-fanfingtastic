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

function! s:next_char_pos(count, f, fwd)
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

function! GetVisualPos()
  let pos1 = getpos("'<")
  let pos2 = getpos("'>")
  let corner = 0
  exec "normal! \<Esc>gv"
  if pos1[1] > 1 && pos2[1] > 1
    let move = 'k'
    let back = 'j'
  elseif pos1[1] < line('$') && pos2[1] > line('$')
    let move = 'j'
    let back = 'k'
  elseif pos1[2] > 1 && pos2[2] > 1
    let move = 'h'
    let back = 'l'
  elseif pos1[2] < len(getline(pos1[1])) && pos2[2] < len(getline(pos2[1]))
    let move = 'l'
    let back = 'h'
  else
    let corner = 1
    " Corner case.
    " visual limits are in opposite extremes of the buffer.
    let move = 'j'
    let back = 'k'
  endif
  exec "normal! " . move . "\<Esc>"
  let pos4 = getpos("'>")
  let pos3 = getpos("'<")
  let back = (corner && pos1 == pos3 && pos2 == pos4) ? '' : back
  exec "normal! gv" . back
  if !corner
    return pos1 == pos3 ? pos2 : pos1
  endif
  return pos1[1] < pos3[1] ? pos1 : pos2
endfunction

function! s:next_char_pos_visual(occurrence)
  let orig_pos = getpos('.')
  let prev_pos = orig_pos
  let occ = a:occurrence
  let cnt = 0
  while cnt < occ
    exe "normal! f" . b:fchar
    let new_pos = getpos('.')
    if new_pos[2] != prev_pos[2]
      " found one
      let prev_pos = new_pos
      let cnt += 1
      "break
    else
      let prev_pos = new_pos
      normal! j0
      if getline('.')[0] == b:fchar
        " found one at the start of a line
        let prev_pos = new_pos
        let new_pos = getpos('.')
        let cnt += 1
        "break
      else
        let new_pos = getpos('.')
        if new_pos[1] == prev_pos[1]
          " last line in the buffer
          " abort and return to original position
          call setpos('.', orig_pos)
          let new_pos = orig_pos
          break
        else
          let prev_pos = new_pos
        endif
      endif
    endif
  endwhile
  call setpos('.', orig_pos)
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
  return s:next_char_pos(a:count, a:f, fwd)
endfunction

function! VisualFindNextChar(args)
  echom string(a:args)
  call s:set_find_char(a:args)
  " this may not work for tT,
  normal! `>
  let new_pos = s:next_char_pos(a:args[0], 1, 1)
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
