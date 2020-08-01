" Vim global plugin to enhace f/F/t/T/;/,
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
"		Israel Chauca F. <israelchauca@gmail.com>
" Description:	Fanf,ingTastic; is a Vim plugin that enhances the builtin
"		f/F/t/T/;/, keys.
" License:	Vim License (see :help license)
" Location:	plugin/fanfingtastic.vim
" Website:	https://github.com/dahu/fanfingtastic
"
" See fanfingtastic.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help fanfingtastic

let g:fanfingtastic_version = '0.3'  " support &selection=exclusive mode

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

let s:fchar = get(s:, 'fchar', '')
let s:fwd = {
      \'f': 1,
      \'F': 0,
      \'t': 1,
      \'T': 0,
      \';': -1,
      \',': -2
      \}
" Options: {{{1

if !exists('g:fing_enabled')
  let g:fing_enabled = 1
endif

" Private Functions: {{{1
function! s:get(var) "{{{2
  return get(s:, a:var, '')
endfunction

function! s:str2collection(str) "{{{2
  if a:str =~ '\m^/.\+/$'
    let pat = join(split(a:str, '/', 1)[1:-2], '/')
  else
    let pat = escape(a:str, '\]^')
    let pat = substitute(pat, '\m^\(.*\)-\(.*\)', '\1\2-', 'g')
    let pat = '[' . pat . ']'
  endif
  return pat
endfunction

function! s:search(fwd, f, ...) "{{{2
  " Define what will be searched.
  let cpat = s:str2collection(s:fchar)
  let pat = a:f ? cpat : (a:fwd ? '\_.\ze' . cpat : cpat . '\zs\_.')
  let b_flag = a:fwd ? '' : 'b'
  " This is for the tx todo.
  let c_flag = !a:0 ? '' : (a:1 && !a:f ? 'c' : '')
  let ic = get(g:, 'fanfingtastic_ignorecase', 0) ? '\c' : '\C'
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
  if &selection == 'exclusive' && a:fwd
    let new_pos[1] += 1
  endif
  return new_pos
endfunction

function! s:get_visual_pos() "{{{2
  let pos1 = getpos("'<")
  let pos2 = getpos("'>")
  let corner = 0

  if pos1[2] > 1 && pos2[2] > 1
    " Case 3 -- selection doesn't touch left margin
    let move = 'h'
    let back = 'l'
  elseif pos1[2] < len(getline(pos1[1])) && pos2[2] < len(getline(pos2[1]))
    " Case 4 -- selection doesn't touch right margin
    let move = 'l'
    let back = 'h'
  elseif pos1[1] > 1 && pos2[1] > 1
    " Case 1 -- selection doesn't touch top margin
    let move = 'k'
    let back = 'j'
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
  return pos1 == pos3 ? pos2 : pos1
endfunction

function! s:set_find_char(args, cmd, a) "{{{2
  if type(a:args) == type('')
    let s:fchar = empty(a:args) ? nr2char(getchar()) : a:args
  elseif len(a:args) == 2
    let s:fchar = a:args[1]
  else
    let s:fchar = nr2char(getchar())
  endif
endfunction

function! s:next_char(count, char, f, fwd) "{{{2
  let afwd = s:fwd[a:fwd]
  if afwd < 0 && !exists('s:ff')
    return [0,0]
  endif
  if get(g:, 'fanfingtastic_use_jumplist', 0)
    normal! m'
  endif
  let s:ffwd = afwd < 0 ? s:ffwd : afwd
  let fwd = afwd >= 0 ? s:ffwd : (afwd == -1 ? s:ffwd : !s:ffwd)
  let s:ff = a:f
  call s:set_find_char(a:char, a:f, afwd)
  if a:f ==? 'f' || get(g:, 'fanfingtastic_fix_t', 0)
    let ccount = a:count
  else
    " This replicates t/T/; + count behaviour.
    let is_t_repeat = afwd < 0
    if a:f ==# 't' && (a:fwd ==# 't' || a:fwd ==# ';')
          \ || a:f ==# 'T' && a:fwd ==# ','
      " Search forward.
      let pat = '\_.\ze'.s:str2collection(s:fchar)
      let flags = 'cWn'
    else
      " Or not.
      let pat = s:str2collection(s:fchar).'\zs\_.'
      let flags = 'cWnb'
    endif
    let is_on_one = getpos('.')[1:2] == searchpos(pat, flags, line('.'))
    if a:count == 1 && is_on_one && (!is_t_repeat || is_t_repeat && &cpo =~ ';')
      return [0,0]
    endif
    if a:count > 1 && a:fwd ==# ';'
      " Case 1 ';'
      let ccount = is_on_one ? a:count - 1 : a:count
    elseif a:count > 1 && a:fwd ==# ','
      " Case 2 ','
      let ccount = a:count
    elseif a:count > 1 && afwd
      " Case 3 't'
      let ccount = is_on_one ? a:count - 1 : a:count
    elseif a:count > 1 && !afwd
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
  " call setpos('.', pos1)
  let pos3 = [0] + s:next_char(a:count, a:char, a:f, a:fwd) + [0]
  if pos3[1] == 0
    exec 'normal! gv'
    return ''
  endif
  call setpos("'[", pos2)
  call setpos("']", pos3)
  " Work around &selection==exclusive right-margin selection grief. See :help 'selection for details.
  if pos2[1] > pos3[1] || (pos2[1] == pos3[1] && pos2[2] > pos3[2])
    exec 'normal! `]' . vmode . '`[o'
  else
    exec 'normal! `[' . vmode . '`]'
  endif
endfunction

function! RepeatSet(buf) "{{{2
" guns' awesome workaround for ./repeat issue
" https://github.com/tpope/vim-repeat/issues/8
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
  if !get(g:, 'fanfingtastic_all_inclusive', 0)
        \ && (a:fwd =~# '[FT]' || a:f =~# '[ft]' && a:fwd == ',' || a:f =~# '[FT]' && a:fwd == ';')
        \ && &selection != 'exclusive'
      let curpos[2] -= 1
  endif
  call setpos("'[", curpos)
  call setpos("']", curpos)
  let pos = [0] + s:next_char(a:count, a:char, a:f, a:fwd) + [0]
  if pos[1] != 0
    call setpos("']", pos)
  endif
  " No need to give a char to jump to with ";" and ",".
  let sufix = a:fwd =~ '[,;]' ? '' : s:fchar
  " Use the dot register to repeat with the c-hange operator.
  let sufix .= v:operator ==# 'c' ? "\<C-R>.\<Esc>" : ""
  let expr = printf("%s\<Plug>fanfingtastic_%s%s", v:operator, a:fwd, sufix)
  silent! call RepeatSet(expr)
  normal! `[v`]
endfunction

function! s:define_alias(alias, chars, bang) "{{{2
  let err = []
  let chars = substitute(substitute(a:chars, "'", '&&', 'g'), '|', '<bar>', 'g')
  let uniq = a:bang ? '' : '<unique>'
  for cmd in ['f', 'F', 't', 'T']
    for [mode, fn] in [['n', ''], ['v', 'visual_'], ['o', 'operator_']]
      try
        exec printf(
              \'%snoremap <silent>%s%s%s :<C-U>call <SID>%snext_char(v:count1,''%s'',''%s'', ''%s'')<CR>',
              \mode, uniq, cmd, a:alias, fn, chars, cmd, cmd)
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
    echom "FanfingTastic: Mapping" . pl . " already exist" . tp
          \ . " for " . join(err, ', ') . " (add ! to override)"
    echohl None
  endif
endfunction

" Public Functions: {{{1
function! FanfingtasticEval(expr)
  return eval(a:expr)
endfunction

" Maps: {{{1

for [mode, fn_prefix] in [['n', ''], ['x', 'visual_'], ['o', 'operator_']]
  for [cmd, arg1, arg2] in [
        \['f', '""', '"f"'],
        \['F', '""', '"F"'],
        \['t', '""', '"t"'],
        \['T', '""', '"T"'],
        \[';', '<SID>get("fchar")', '<SID>get("ff")'],
        \[',', '<SID>get("fchar")', '<SID>get("ff")']
        \]
    exec printf(
          \ '%snoremap <silent><Plug>fanfingtastic_%s '
          \ . ':<C-U>call <SID>%snext_char(v:count1, %s, %s, "%s")<CR>',
          \ mode, cmd, fn_prefix, arg1, arg2, cmd)
  endfor
endfor
unlet mode cmd fn_prefix arg1 arg2

function! FanfingTasticEnable(...)
  let g:fing_enabled = a:0 ? a:1 : 1

  for mode in ['n', 'x', 'o']
    for cmd in ['f', 'F', 't', 'T', ';', ',']
      if g:fing_enabled
        if hasmapto('<Plug>fanfingtastic_' . cmd, mode)
          continue
        endif
        if !exists('g:runVimTests')
              \ && get(g:, 'fanfingtastic_map_over_leader', 0)
              \ && get(g:, 'mapleader', '') ==# cmd
          continue
        endif
        silent! exec printf('%smap <unique><silent> %s <Plug>fanfingtastic_%s', mode, cmd, cmd)
      else
        silent! exec printf('%sunmap %s', mode, cmd)
      endif
    endfor
  endfor
  unlet cmd mode
endfunction

function! FanfingTasticDisable()
  let g:fing_enabled = a:0 ? a:1 : 0
  call FanfingTasticEnable(g:fing_enabled)
endfunction

if g:fing_enabled
  call FanfingTasticEnable()
endif

" Commands: {{{1
command! -nargs=+ -bar -bang FanfingTasticAlias call <SID>define_alias(<f-args>, <bang>0)

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
