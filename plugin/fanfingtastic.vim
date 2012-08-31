" Vim global plugin to enhace f/F/t/T/;/,
" Maintainer:	Israel Chauca F. <israelchauca@gmail.com>
"		Barry Arthur <barry.arthur@gmail.com>
" Version:	0.1
" Description:	Fanf,ingTastic; is a Vim plugin that enhances the builtin
"		f/F/t/T/;/, keys.
" Last Change:	2012-08-31
" License:	Vim License (see :help license)
" Location:	plugin/fanfingtastic.vim
" Website:	https://github.com/dahu/fanfingtastic
"
" See fanfingtastic.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help fanfingtastic

let g:fanfingtastic_version = '0.1'

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development.
" XXX The conditions are only as examples of how to use them. Change them as
" needed. XXX
"if exists("g:loaded_fanfingtastic")
"      \ || v:version < 700
"      \ || v:version == 703 && !has('patch338')
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_fanfingtastic = 1

let g:fchar = ''
" Options: {{{1
if !exists('g:fanfingtastic_ignorecase')
  let g:fanfingtastic_ignorecase = 0
endif

" Private Functions: {{{1
function! s:search(fwd, f, ...) "{{{2
  " Define what will be searched.
  let pat = a:f ? g:fchar : (a:fwd ? '\_.\ze'.g:fchar : g:fchar.'\zs\_.')
  let b_flag = a:fwd ? '' : 'b'
  " This is for the tx todo.
  let c_flag = !a:0 ? '' : (a:1 && !a:f ? 'c' : '')
  let ic = g:fanfingtastic_ignorecase ? '\c' : '\C'
  return searchpos(ic.'\m'.pat, 'W'.b_flag.c_flag)
endfunction

function! s:next_char_pos(count, f, fwd) "{{{2
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

function! s:get_visual_pos() "{{{2
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

function! s:set_find_char(args) "{{{2
  "call inputsave()
  if type(a:args) == type('')
    let g:fchar = empty(a:args) ? nr2char(getchar()) : a:args
  elseif len(a:args) == 2
    let g:fchar = a:args[1]
  else
    let g:fchar = nr2char(getchar())
  endif
  "call inputrestore()
endfunction

function! s:next_char(count, char, f, fwd) "{{{2
  let g:ffwd = a:fwd < 0 ? g:ffwd : a:fwd
  let fwd = a:fwd >= 0 ? g:ffwd : (a:fwd == -1 ? g:ffwd : !g:ffwd)
  let g:ff = a:f
  call s:set_find_char(a:char)
  if a:f ==? 'f'
    let ccount = a:count
  else
    " This replicates t/T/; + count behaviour.
    let is_t_repeat = a:fwd < 0
    if a:f ==# 't' && (a:fwd == 1 || a:fwd == -1)
          \ || a:f ==# 'T' && a:fwd == -2
      " Search forward.
      let pat = '\_.\ze'.g:fchar
      let flags = 'cWn'
    else
      " Or not.
      let pat = g:fchar.'\zs\_.'
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

function! s:visual_next_char(count, char, f, fwd) "{{{2
  let pos1 = s:get_visual_pos()
  let pos2 = getpos("'<") == pos1 ? getpos("'>") : getpos("'<")
  call visualmode(1)
  call setpos('.', pos1)
  let pos3 = [0] + s:next_char(a:count, a:char, a:f, a:fwd) + [0]
  if pos3[1] == 0
    return ''
  endif
  call setpos("'[", pos2)
  call setpos("']", pos3)
  normal! `[v`]
endfunction

function! s:operator_next_char(count, char, f, fwd) "{{{2
  call setpos("'[", getpos('.'))
  let pos = [0] + s:next_char(a:count, a:char, a:f, a:fwd) + [0]
  if pos[1] == 0
    return ''
  endif
  call setpos("']", pos)
  normal! `[v`]
endfunction

" Public Functions: {{{1
function! FanfingtasticEval(expr)
  return eval(a:expr)
endfunction

" Maps: {{{1

nnoremap  <Plug>fanfingtastic_f :<C-U>call <SID>next_char(v:count1, ''     , 'f'   ,  1)<CR>
nnoremap  <Plug>fanfingtastic_F :<C-U>call <SID>next_char(v:count1, ''     , 'F'   ,  0)<CR>
nnoremap  <Plug>fanfingtastic_t :<C-U>call <SID>next_char(v:count1, ''     , 't'   ,  1)<CR>
nnoremap  <Plug>fanfingtastic_T :<C-U>call <SID>next_char(v:count1, ''     , 'T'   ,  0)<CR>
nnoremap  <Plug>fanfingtastic_; :<C-U>call <SID>next_char(v:count1, g:fchar, g:ff, -1)<CR>
nnoremap  <Plug>fanfingtastic_, :<C-U>call <SID>next_char(v:count1, g:fchar, g:ff, -2)<CR>

vnoremap  <Plug>fanfingtastic_f :<C-U>call <SID>visual_next_char(v:count1, ''     , 'f'   ,  1)<CR>
vnoremap  <Plug>fanfingtastic_F :<C-U>call <SID>visual_next_char(v:count1, ''     , 'F'   ,  0)<CR>
vnoremap  <Plug>fanfingtastic_t :<C-U>call <SID>visual_next_char(v:count1, ''     , 't'   ,  1)<CR>
vnoremap  <Plug>fanfingtastic_T :<C-U>call <SID>visual_next_char(v:count1, ''     , 'T'   ,  0)<CR>
vnoremap  <Plug>fanfingtastic_; :<C-U>call <SID>visual_next_char(v:count1, g:fchar, g:ff, -1)<CR>
vnoremap  <Plug>fanfingtastic_, :<C-U>call <SID>visual_next_char(v:count1, g:fchar, g:ff, -2)<CR>

onoremap  <Plug>fanfingtastic_f :<C-U>call <SID>operator_next_char(v:count1, ''     , 'f'   ,  1)<CR>
onoremap  <Plug>fanfingtastic_F :<C-U>call <SID>operator_next_char(v:count1, ''     , 'F'   ,  0)<CR>
onoremap  <Plug>fanfingtastic_t :<C-U>call <SID>operator_next_char(v:count1, ''     , 't'   ,  1)<CR>
onoremap  <Plug>fanfingtastic_T :<C-U>call <SID>operator_next_char(v:count1, ''     , 'T'   ,  0)<CR>
onoremap  <Plug>fanfingtastic_; :<C-U>call <SID>operator_next_char(v:count1, g:fchar, g:ff, -1)<CR>
onoremap  <Plug>fanfingtastic_, :<C-U>call <SID>operator_next_char(v:count1, g:fchar, g:ff, -2)<CR>

for m in ['n', 'v', 'o']
  for c in ['f', 'F', 't', 'T', ';', ',']
    if !hasmapto('<Plug>fanfingtastic_' . c, m)
      sil! exec m . 'map <unique><silent> ' . c . ' <Plug>fanfingtastic_' . c
    endif
  endfor
endfor
" Commands: {{{1
command! -nargs=0 -bar MyCommand1 call <SID>MyScriptLocalFunction()
command! -nargs=0 -bar MyCommand2 call MyPublicFunction()

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
