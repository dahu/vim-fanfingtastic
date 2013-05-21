" Vim global plugin to enhace f/F/t/T/;/,
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
"		Israel Chauca F. <israelchauca@gmail.com>
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

let g:fanfingtastic_version = '0.2'  " added . support using tpope's repeat

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

let s:fchar = ''
" Options: {{{1
if !exists('g:fanfingtastic_ignorecase')
  let g:fanfingtastic_ignorecase = 0
endif

if !exists('g:fanfingtastic_map_over_leader')
  let g:fanfingtastic_map_over_leader = 0
endif

if !exists('g:fanfingtastic_fix_t')
  let g:fanfingtastic_fix_t = 0
endif

if !exists('g:fanfingtastic_use_jumplist')
  let g:fanfingtastic_use_jumplist = 0
endif

if !exists('g:fanfingtastic_all_inclusive')
  let g:fanfingtastic_all_inclusive = 0
endif

" Private Functions: {{{1
function! s:get(var) "{{{2
  let var = 's:'.a:var
  return exists(var) ? eval(var) : ''
endfunction

function! s:str2coll(str) "{{{2
  let pat = escape(a:str, '\]^')
  let pat = substitute(pat, '\m^\(.*\)-\(.*\)', '\1\2-', 'g')
  let pat = '[' . pat . ']'
  return pat
endfunction

function! s:search(fwd, f, ...) "{{{2
  " Define what will be searched.
  let cpat = s:str2coll(s:fchar)
  let pat = a:f ? cpat : (a:fwd ? '\_.\ze' . cpat : cpat . '\zs\_.')
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

function! s:set_find_char(args, cmd, a) "{{{2
  "call inputsave()
  " Do not use this if 'showcmd' is not set or running tests.
  " this_is_a_test
  " let showcmd = a:a >= 0 && &showcmd && !exists('g:runVimTests')
  " if showcmd
  "   " show command.
  "   let lead = repeat(' ', &columns - 11)
  "   let cr = repeat("\n", &cmdheight - 1)
  "   echon cr . lead . a:cmd
  " endif

  if type(a:args) == type('')
    let s:fchar = empty(a:args) ? nr2char(getchar()) : a:args
  elseif len(a:args) == 2
    let s:fchar = a:args[1]
  else
    let s:fchar = nr2char(getchar())
  endif
  "call inputrestore()
  " if showcmd
  "   "call feedkeys((v:operator ==# 'c' ? "\<CR>" : "\<Esc>"), 'n')
  "   call feedkeys("\<CR>", 'n')
  " endif
endfunction

function! s:next_char(count, char, f, fwd) "{{{2
  if a:fwd < 0 && !exists('s:ff')
    return [0,0]
  endif
  if g:fanfingtastic_use_jumplist
    normal! m'
  endif
  let s:ffwd = a:fwd < 0 ? s:ffwd : a:fwd
  let fwd = a:fwd >= 0 ? s:ffwd : (a:fwd == -1 ? s:ffwd : !s:ffwd)
  let s:ff = a:f
  call s:set_find_char(a:char, a:f, a:fwd)
  if a:f ==? 'f' || g:fanfingtastic_fix_t
    let ccount = a:count
  else
    " This replicates t/T/; + count behaviour.
    let is_t_repeat = a:fwd < 0
    if a:f ==# 't' && (a:fwd == 1 || a:fwd == -1)
          \ || a:f ==# 'T' && a:fwd == -2
      " Search forward.
      let pat = '\_.\ze'.s:str2coll(s:fchar)
      let flags = 'cWn'
    else
      " Or not.
      let pat = s:str2coll(s:fchar).'\zs\_.'
      let flags = 'cWnb'
    endif

    let is_on_one = getpos('.')[1:2] == searchpos(pat, flags, line('.'))
    if a:count == 1 && is_on_one && (!is_t_repeat || is_t_repeat && &cpo =~ ';')
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
  let vmode = visualmode(1)
  call setpos('.', pos1)
  let pos3 = [0] + s:next_char(a:count, a:char, a:f, a:fwd) + [0]
  if pos3[1] == 0
    return ''
  endif
  call setpos("'[", pos2)
  call setpos("']", pos3)
  exec 'normal! `[' . vmode . '`]'
endfunction

" guns' awesome workaround for ./repeat issue
" https://github.com/tpope/vim-repeat/issues/8
function! RepeatSet(buf)
  call repeat#set(a:buf)

  augroup repeat_tick
    autocmd!
    autocmd CursorMoved <buffer>
          \ let g:repeat_tick = b:changedtick
          \ | autocmd! repeat_tick
  augroup END
endfunction

function! s:operator_next_char(count, char, f, fwd) "{{{2
  let curpos = getpos('.')
  let curpos[2] -= (g:fanfingtastic_all_inclusive || a:fwd) ? 0 : 1
  call setpos("'[", curpos)
  call setpos("']", curpos)
  let pos = [0] + s:next_char(a:count, a:char, a:f, a:fwd) + [0]
  "if pos[1] == 0
    "return ''
  "endif
  if pos[1] != 0
    call setpos("']", pos)
  endif
  " Use the dot register to repeat with the c-hange operator.
  let sufix = v:operator ==# 'c' ? "\<C-R>.\<Esc>" : ""
  silent! call RepeatSet(v:operator . "\<Plug>fanfingtastic_" . a:f . s:fchar . sufix)
  normal! `[v`]
endfunction

function! s:define_alias(alias, chars, bang) "{{{2
  let err = []
  let chars = substitute(a:chars, "'", '&&', 'g')
  let uniq = a:bang ? '' : '<unique>'
  for cmd in ['f', 'F', 't', 'T']
    let fwd = cmd =~# '[ft]'
    for [m, fun] in [['n', ''], ['v', 'visual_'], ['o', 'operator_']]
      try
        exe m . "nore <silent>" . uniq . " " . cmd . a:alias
              \ . " :<C-U>call <SID>" . fun . "next_char(v:count1, '"
              \ . chars . "', '" . cmd . "', " . fwd . ")<CR>"
      catch /^Vim\%((\a\+)\)\=:E227/
        call add(err, matchstr(v:exception, '\S\+$'))
      endtry
    endfor
  endfor
  if !empty(err)
    call filter(err, 'count(err, v:val) == 1')
    let pl = len(err) == 1 ? '' : 's'
    let tp = len(err) == 1 ? 's' : ''
    echohl ErrorMsg
    echom "FanfingTastic: Mapping" . pl . " already exist" . tp . " for " . join(err, ', ') . " (add ! to override)"
    echohl None
  endif
endfunction

" Public Functions: {{{1
function! FanfingtasticEval(expr)
  return eval(a:expr)
endfunction

" Maps: {{{1

nnoremap  <Plug>fanfingtastic_f :<C-U>call <SID>next_char(v:count1, ''               , 'f'           ,  1)<CR>
nnoremap  <Plug>fanfingtastic_F :<C-U>call <SID>next_char(v:count1, ''               , 'F'           ,  0)<CR>
nnoremap  <Plug>fanfingtastic_t :<C-U>call <SID>next_char(v:count1, ''               , 't'           ,  1)<CR>
nnoremap  <Plug>fanfingtastic_T :<C-U>call <SID>next_char(v:count1, ''               , 'T'           ,  0)<CR>
nnoremap  <Plug>fanfingtastic_; :<C-U>call <SID>next_char(v:count1, <SID>get('fchar'), <SID>get('ff'), -1)<CR>
nnoremap  <Plug>fanfingtastic_, :<C-U>call <SID>next_char(v:count1, <SID>get('fchar'), <SID>get('ff'), -2)<CR>

vnoremap  <Plug>fanfingtastic_f :<C-U>call <SID>visual_next_char(v:count1, ''               , 'f'           ,  1)<CR>
vnoremap  <Plug>fanfingtastic_F :<C-U>call <SID>visual_next_char(v:count1, ''               , 'F'           ,  0)<CR>
vnoremap  <Plug>fanfingtastic_t :<C-U>call <SID>visual_next_char(v:count1, ''               , 't'           ,  1)<CR>
vnoremap  <Plug>fanfingtastic_T :<C-U>call <SID>visual_next_char(v:count1, ''               , 'T'           ,  0)<CR>
vnoremap  <Plug>fanfingtastic_; :<C-U>call <SID>visual_next_char(v:count1, <SID>get('fchar'), <SID>get('ff'), -1)<CR>
vnoremap  <Plug>fanfingtastic_, :<C-U>call <SID>visual_next_char(v:count1, <SID>get('fchar'), <SID>get('ff'), -2)<CR>

onoremap  <silent> <Plug>fanfingtastic_f :<C-U>call <SID>operator_next_char(v:count1, ''               , 'f'           ,  1)<CR>
onoremap  <silent> <Plug>fanfingtastic_F :<C-U>call <SID>operator_next_char(v:count1, ''               , 'F'           ,  0)<CR>
onoremap  <silent> <Plug>fanfingtastic_t :<C-U>call <SID>operator_next_char(v:count1, ''               , 't'           ,  1)<CR>
onoremap  <silent> <Plug>fanfingtastic_T :<C-U>call <SID>operator_next_char(v:count1, ''               , 'T'           ,  0)<CR>
onoremap  <silent> <Plug>fanfingtastic_; :<C-U>call <SID>operator_next_char(v:count1, <SID>get('fchar'), <SID>get('ff'), -1)<CR>
onoremap  <silent> <Plug>fanfingtastic_, :<C-U>call <SID>operator_next_char(v:count1, <SID>get('fchar'), <SID>get('ff'), -2)<CR>

for m in ['n', 'x', 'o']
  for c in ['f', 'F', 't', 'T', ';', ',']
    if !hasmapto('<Plug>fanfingtastic_' . c, m)
      if !exists('g:runVimTests')
        if exists('g:mapleader') && (c == g:mapleader) && (g:fanfingtastic_map_over_leader == 0)
          continue
        endif
      endif
      sil! exec m . 'map <unique><silent> ' . c . ' <Plug>fanfingtastic_' . c
    endif
  endfor
endfor

" Commands: {{{1
command! -nargs=+ -bar -bang FanfingTasticAlias call <SID>define_alias(<f-args>, <bang>0)

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
