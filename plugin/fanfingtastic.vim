let b:fchar = ''

function! s:next_char_pos(occurrence)
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
  let cur_pos = getpos('.')
  let new_pos = s:next_char_pos(a:args[0])
  if cur_pos != new_pos
    call setpos('.', new_pos)
  endif
endfunction

function! VisualFindNextChar(args)
  echo a:args
  call s:set_find_char(a:args)
  let cur_pos = getpos('.')
  let new_pos = s:next_char_pos(a:args[0])
  if cur_pos != new_pos
    normal! gv
    call setpos("'`", new_pos)
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
