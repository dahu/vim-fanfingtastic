let b:fchar = ''

function! s:next_char_pos()
  let orig_pos = getpos('.')
  let prev_pos = orig_pos
  while 1
    exe "normal! f" . b:fchar
    let new_pos = getpos('.')
    if new_pos[2] != prev_pos[2]
      break
    else
      let prev_pos = new_pos
      normal! j0
      if getline('.')[0] == b:fchar
        let new_pos = getpos('.')
        break
      endif
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
  endwhile
  call setpos('.', orig_pos)
  return new_pos
endfunction

function! s:set_find_char(...)
  if a:0
    echo a:1
    let b:fchar = a:1
  else
    let b:fchar = nr2char(getchar())
  endif
endfunction

function! FindNextChar(...)
  call call('s:set_find_char', a:000)
  let cur_pos = getpos('.')
  let new_pos = s:next_char_pos()
  if cur_pos != new_pos
    call setpos('.', new_pos)
  endif
endfunction

function! VisualFindNextChar(...)
  call call('s:set_find_char', a:000)
  let cur_pos = getpos('.')
  let new_pos = s:next_char_pos()
  if cur_pos != new_pos
    "call setpos("'`", cur_pos)
    normal! gv
    call setpos("'`", new_pos)
    normal! ``
  endif
endfunction

function! OperatorFindNextChar(...)
  call call('s:set_find_char', a:000)
  let cur_pos = getpos('.')
  let new_pos = s:next_char_pos()
  echom "operator=#" . v:operator . "#"
  if cur_pos != new_pos
    if v:operator == 'c'
      exe "normal vf" . b:fchar . 'x'
      startinsert
    else
      exe "normal vf" . b:fchar . v:operator
    endif
  endif
endfunction

nnoremap f :call FindNextChar()<cr>
nnoremap ; :call FindNextChar(b:fchar)<cr>

vnoremap f <esc>:call VisualFindNextChar()<cr>
vnoremap ; <esc>:call VisualFindNextChar(b:fchar)<cr>

onoremap f <esc>:call OperatorFindNextChar()<cr>
onoremap ; <esc>:call OperatorFindNextChar(b:fchar)<cr>

finish

this dam this test is here
and another test here
this this test is here
and another test here
