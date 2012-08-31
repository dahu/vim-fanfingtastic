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
  if pos1[2] > 1 && pos2[2] > 1
    " Case 3
    let move = 'h'
    let back = 'l'
  elseif pos1[2] < len(getline(pos1[1])) && pos2[2] < len(getline(pos2[1]))
    " Case 4
    let move = 'l'
    let back = 'h'
  elseif pos1[1] > 1 && pos2[1] > 1
    " Case 1
    let move = 'k'
    let back = 'j'
  elseif pos1[1] < line('$') && pos2[1] > line('$')
    " Case 2
    let move = 'j'
    let back = 'k'
  else
    " Case 5
    let corner = 1
    " Corner case.
    " visual limits are in opposite extremes of the buffer.
    let move = 'j'
    let back = 'k'
  endif
  exec "normal! \<Esc>gv" . move . "\<Esc>"
  let pos3 = getpos("'<")
  let pos4 = getpos("'>")
  let back = (corner && pos1 == pos3 && pos2 == pos4) ? '' : back
  exec "normal! gv" . back . "\<Esc>"
  if !corner
    "if pos1 != pos3 && pos2 != pos4
      "return pos1 == pos4 ? pos2 : pos1
    "endif
    return pos1 == pos3 ? pos2 : pos1
  endif
  return pos1 == pos3 ? pos2 : pos1
endfunction

function! s:next_char_pos_visual(occurrence) "{{{
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
endfunction "}}}

function! s:set_find_char(args)
  "call inputsave()
  if type(a:args) == type('')
    let b:fchar = empty(a:args) ? nr2char(getchar()) : a:args
  elseif len(a:args) == 2
    let b:fchar = a:args[1]
  else
    let b:fchar = nr2char(getchar())
  endif
  "call inputrestore()
endfunction

function! NextChar(count, char, f, fwd)
  let b:ffwd = a:fwd < 0 ? b:ffwd : a:fwd
  let fwd = a:fwd >= 0 ? b:ffwd : (a:fwd == -1 ? b:ffwd : !b:ffwd)
  let b:ff = a:f
  call s:set_find_char(a:char)
  if a:f ==? 'f'
    let ccount = a:count
  else
    " This replicates t/T/; + count behaviour.
    let is_t_repeat = a:fwd < 0
    if a:f ==# 't' && (a:fwd == 1 || a:fwd == -1)
          \ || a:f ==# 'T' && a:fwd == -2
      " Search forward.
      let pat = '\_.\ze'.b:fchar
      let flags = 'cWn'
    else
      " Or not.
      let pat = b:fchar.'\zs\_.'
      let flags = 'cWnb'
    endif

    let is_on_one = getpos('.')[1:2] == searchpos(pat, flags, line('.'))
    if a:count == 1 && !is_t_repeat && is_on_one
      return [0,0]
    endif
    if a:count > 1 && a:fwd == -1
      " Case 1 ';'
      let ccount = is_on_one ? a:count - 1 : a:count
    elseif a:count > 1 && a:fwd == -2
      " Case 2 ','
      let ccount = a:count
    elseif a:count > 1 && a:fwd
      " Case 3 't'
      let ccount = is_on_one ? a:count - 1 : a:count
    elseif a:count > 1 && !a:fwd
      " Case 4 'T'
      let ccount = is_on_one ? a:count - 1 : a:count
    else
      let ccount = a:count
    endif
  endif

  return s:next_char_pos(ccount, a:f =~? 'f', fwd)
endfunction

function! VisualNextChar(count, char, f, fwd)
  let pos1 = GetVisualPos()
  let pos2 = getpos("'<") == pos1 ? getpos("'>") : getpos("'<")
  call visualmode(1)
  call setpos('.', pos1)
  let pos3 = [0] + NextChar(a:count, a:char, a:f, a:fwd) + [0]
  if pos3[1] == 0
    return ''
  endif
  call setpos("'[", pos2)
  call setpos("']", pos3)
  normal! `[v`]
endfunction

function! OperatorNextChar(count, char, f, fwd)
  call setpos("'[", getpos('.'))
  let pos = [0] + NextChar(a:count, a:char, a:f, a:fwd) + [0]
  if pos[1] == 0
    return ''
  endif
  call setpos("']", pos)
  normal! `[v`]
endfunction

nnoremap  <silent> f :<C-U>call NextChar(v:count1, ''     , 'f'   ,  1)<CR>
nnoremap  <silent> F :<C-U>call NextChar(v:count1, ''     , 'F'   ,  0)<CR>
nnoremap  <silent> t :<C-U>call NextChar(v:count1, ''     , 't'   ,  1)<CR>
nnoremap  <silent> T :<C-U>call NextChar(v:count1, ''     , 'T'   ,  0)<CR>
nnoremap  <silent> ; :<C-U>call NextChar(v:count1, b:fchar, b:ff, -1)<CR>
nnoremap  <silent> , :<C-U>call NextChar(v:count1, b:fchar, b:ff, -2)<CR>

vnoremap  <silent> f :<C-U>call VisualNextChar(v:count1, ''     , 'f'   ,  1)<CR>
vnoremap  <silent> F :<C-U>call VisualNextChar(v:count1, ''     , 'F'   ,  0)<CR>
vnoremap  <silent> t :<C-U>call VisualNextChar(v:count1, ''     , 't'   ,  1)<CR>
vnoremap  <silent> T :<C-U>call VisualNextChar(v:count1, ''     , 'T'   ,  0)<CR>
vnoremap  <silent> ; :<C-U>call VisualNextChar(v:count1, b:fchar, b:ff, -1)<CR>
vnoremap  <silent> , :<C-U>call VisualNextChar(v:count1, b:fchar, b:ff, -2)<CR>

onoremap  <silent> f :<C-U>call OperatorNextChar(v:count1, ''     , 'f'   ,  1)<CR>
onoremap  <silent> F :<C-U>call OperatorNextChar(v:count1, ''     , 'F'   ,  0)<CR>
onoremap  <silent> t :<C-U>call OperatorNextChar(v:count1, ''     , 't'   ,  1)<CR>
onoremap  <silent> T :<C-U>call OperatorNextChar(v:count1, ''     , 'T'   ,  0)<CR>
onoremap  <silent> ; :<C-U>call OperatorNextChar(v:count1, b:fchar, b:ff, -1)<CR>
onoremap  <silent> , :<C-U>call OperatorNextChar(v:count1, b:fchar, b:ff, -2)<CR>
