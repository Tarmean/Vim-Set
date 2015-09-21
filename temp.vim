function! Loop()
    "call feedkeys("b")
    echo nr2char(getchar(0))
    " let g:command = ""
    " let g:running = 1
    " while g:running
    "     let i = 0
    "     while i < len(g:command) && len(g:command)>0
    "         call getchar()
    "         let i+=1
    "     endwhile
    "     let c = sneak#util#getchar()
    "     if c == ''
    "         let g:running = 0
    "     endif
    "     let g:command .= c
    "     call feedkeys(g:command)
    "     sleep
    " endwhile
endfunction

augroup Test
    au!
    " autocmd CursorMoved * echo "test"
augroup END

function! TestFeed()
    call feedkeys("y")
    call feedkeys("s")
    call feedkeys("i")
    call feedkeys("w")
    call feedkeys('"')
endfunction

" This method is always called during fanout, even when a bad user input causes
" s:apply_user_input_next to not be called. We detect that and force the method
" to be called to continue the fanout process
function! Detect_bad_input()
  if !s:valid_input
    " We ignore the bad input and force invoke s:apply_user_input_next
    call feedkeys("\<Plug>(multiple-cursors-apply)")
    let s:bad_input += 1
  endif
endfunction
let s:bad_input = 0

" Wrapper around getchar() that returns the string representation of the user
" input
function! Get_char()
  let c = getchar()
  " If the character is a number, then it's not a special key
  if type(c) == 0
    let c = nr2char(c)
  endif
  return c
endfunction

" Return the content of the buffer between the input region. This is used to
" find the next match in the buffer
" Mode change: Normal -> Normal
" Cursor change: None
function! s:get_text(region)
  let lines = getline(a:region[0][0], a:region[1][0])
  let lines[-1] = lines[-1][:a:region[1][1] - 1]
  let lines[0] = lines[0][a:region[0][1] - 1:]
  return join(lines, "\n")
endfunction


" Take the user input and apply it at every cursor
function! Process_user_input()
  " Grr this is frustrating. In Insert mode, between the feedkey call and here,
  " the current position could actually CHANGE for some odd reason. Forcing a
  " position reset here
  " call cursor(s:cm.get_current().position)

  " Before applying the user input, we need to revert back to the mode the user
  " was in when the input was entered
  " call s:revert_mode(s:to_mode, s:from_mode)

  " Update the line length BEFORE applying any actions. TODO(terryma): Is there
  " a better place to do this?
  " call s:cm.get_current().update_line_length()
  let s:saved_linecount = line('$')

  " Restore unnamed register only in Normal mode. This should happen before user
  " input is processed.
  if s:from_mode ==# 'n' || s:from_mode ==# 'v' || s:from_mode ==# 'V'
    " call s:cm.get_current().restore_unnamed_register()
  endif

  " Apply the user input. Note that the above could potentially change mode, we
  " use the mapping below to help us determine what the new mode is
  " Note that it's possible that \<Plug>(multiple-cursors-apply) never gets called, we have a
  " detection mechanism using \<Plug>(multiple-cursors-detect). See its documentation for more details

  " Assume that input is not valid
  let s:valid_input = 0

  " If we're coming from insert mode or going into insert mode, always chain the
  " undos together.
  " FIXME(terryma): Undo always places the cursor at the beginning of the line.
  " Figure out why.
  let s:to_mode = 'n'
  if s:from_mode ==# 'i' || s:to_mode ==# 'i'
    silent! undojoin | call Feedkeys(s:char."\<Plug>(multiple-cursors-apply)")
  else
    call Feedkeys(s:char."\<Plug>(multiple-cursors-apply)")
  endif

  " Even when s:char produces invalid input, this method is always called. The
  " 't' here is important
  call feedkeys("\<Plug>(multiple-cursors-detect)", 't')
endfunction


" Consume all the additional character the user typed between the last
" getchar() and here, to avoid potential race condition.
let g:saved_keys = ""
function! Feedkeys(keys)
  while 1
    let c = getchar(0)
    let char_type = type(c)
    " Checking type is important, when strings are compared with integers,
    " strings are always converted to ints, and all strings are equal to 0
    if char_type == 0
      if c == 0
        break
      else
        let g:saved_keys .= nr2char(c)
      endif
    elseif char_type == 1 " char with more than 8 bits (as string)
      let g:saved_keys .= c
    endif
  endwhile
  call feedkeys(a:keys)
endfunction


" Apply the user input at the next cursor location
function! Apply_user_input_next(mode)
  let s:valid_input = 1

  " Save the current mode, only if we haven't already
  if empty(s:to_mode)
    let s:to_mode = a:mode
    if s:to_mode ==# 'v'
      if visualmode() ==# 'V'
        let s:to_mode = 'V'
      endif
    endif
  endif

  " Update the current cursor's information
  " let changed = s:cm.update_current()

  " Advance the cursor index
  " call s:cm.next()

  " We're done if we're made the full round
  " if s:cm.loop_done()
  "   if s:to_mode ==# 'v' || s:to_mode ==# 'V'
  "     " This is necessary to set the "'<" and "'>" markers properly
  "     call s:update_visual_markers(s:cm.get_current().visual)
  "   endif
  "   call feedkeys("\<Plug>(multiple-cursors-wait)")
  " else
    " Continue to next
    call feedkeys("\<Plug>(multiple-cursors-input)")
  " endif
endfunction

let s:retry_keys = ""
function! s:display_error()
  if s:bad_input == 1
        \ && s:from_mode ==# 'n'
        \ && has_key(g:multi_cursor_normal_maps, s:char[0])
    " we couldn't replay it anywhere but we're told it's the beginning of a
    " multi-character map like the `d` in `dw`
    let s:retry_keys = s:char
  else
    let s:retry_keys = ""
    if s:bad_input > 0
      echohl ErrorMsg |
            \ echo "Key '".s:char."' cannot be replayed at ".
            \ s:bad_input." cursor location".(s:bad_input == 1 ? '' : 's') |
            \ echohl Normal
    endif
  endif
  let s:bad_input = 0
endfunction
 
function! s:skip_latency_measure()
  if g:multi_cursor_debug_latency
    let s:skip_latency_measure = 1
  endif
endfunction

function! s:apply_highlight_fix()
  " Only do this if we're on the last character of the line
  if col('.') == col('$')
    let s:saved_line = getline('.')
    if s:from_mode ==# 'i'
      silent! undojoin | call setline('.', s:saved_line.' ')
    else
      call setline('.', s:saved_line.' ')
    endif
  endif
endfunction
let s:saved_lines = 0
function! s:revert_highlight_fix()
  if type(s:saved_line) == 1
    if s:from_mode ==# 'i'
      silent! undojoin | call setline('.', s:saved_line)
    else
      call setline('.', s:saved_line)
    endif
  endif
  let s:saved_line = 0
endfunction
function! s:end_latency_measure()
  if g:multi_cursor_debug_latency && !empty(s:char)
    if empty(s:latency_debug_file)
      let s:latency_debug_file = tempname()
      exec 'redir >> '.s:latency_debug_file
        silent! echom "Starting latency debug at ".reltimestr(reltime())
      redir END
    endif

    if !s:skip_latency_measure
      exec 'redir >> '.s:latency_debug_file
        silent! echom "Processing '".s:char."' took ".string(str2float(reltimestr(reltime(s:start_time)))*1000).' ms in '.s:cm.size().' cursors. mode = '.s:from_mode
      redir END
    endif
  endif
  let s:skip_latency_measure = 0
endfunction
let s:latency_debug_file = ''
function! s:start_latency_measure()
  if g:multi_cursor_debug_latency
    let s:start_time = reltime()
  endif
endfunction

function! Wait_for_user_input(mode)
  call s:display_error()

  let s:from_mode = a:mode
  if empty(a:mode)
    let s:from_mode = s:to_mode
  endif
  let s:to_mode = ''

  " Right before redraw, apply the highlighting bug fix
   call s:apply_highlight_fix()

  redraw

  " Immediately revert the change to leave the user's buffer unchanged
   call s:revert_highlight_fix()

   call s:end_latency_measure()

  let s:char = s:retry_keys . g:saved_keys
  if len(g:saved_keys) == 0
    let s:char .= Get_char()
  else
    let g:saved_keys = ""
  endif

  if s:from_mode ==# 'i' && has_key(g:multi_cursor_insert_maps, s:last_char())
    let c = getchar(0)
    let char_type = type(c)
    let poll_count = 0
    while char_type == 0 && c == 0 && poll_count < &timeoutlen
      sleep 1m
      let c = getchar(0)
      let char_type = type(c)
      let poll_count += 1
    endwhile

    if char_type == 0 && c != 0
      let s:char .= nr2char(c)
    elseif char_type == 1 " char with more than 8 bits (as string)
      let s:char .= c
    endif
  elseif s:from_mode !=# 'i' && s:char[0] ==# ":"
    call feedkeys(s:char)
    call s:cm.reset(1, 1)
    return
  elseif s:from_mode ==# 'n'
    while match(s:last_char(), "\\d") == 0
      let s:char .= Get_char()
    endwhile
  endif

  call s:start_latency_measure()

  " Clears any echoes we might've added
  normal! :<Esc>

  if s:exit()
    return
  endif

  " If the key is a special key and we're in the right mode, handle it
  if index(get(s:special_keys, s:from_mode, []), s:last_char()) != -1
    call s:handle_special_key(s:last_char(), s:from_mode)
    call s:skip_latency_measure()
   else
    " call s:cm.start_loop()
    call Feedkeys("\<Plug>(multiple-cursors-input)")
  endif
endfunction
" Quits multicursor mode and clears all cursors. Return true if exited
" successfully.
"
" These keys don't get faned out to all cursor locations. Instead, they're used
" to add new / remove existing cursors
" Precondition: The function is only called when the keys and mode respect the
" setting in s:special_keys
function! s:handle_special_key(key, mode)
  " Use feedkeys here instead of calling the function directly to prevent
  " increasing the call stack, since feedkeys execute after the current call
  " finishes
  if a:key == g:multi_cursor_next_key
    if s:use_word_boundary == 1
      call s:feedkeys("\<Plug>(multiple-cursors-new-word)")
    else
      call s:feedkeys("\<Plug>(multiple-cursors-new)")
    endif
  elseif a:key == g:multi_cursor_prev_key
    call s:feedkeys("\<Plug>(multiple-cursors-prev)")
  elseif a:key == g:multi_cursor_skip_key
    call s:feedkeys("\<Plug>(multiple-cursors-skip)")
  endif
endfunction

let s:special_keys = {
      \ 'v': [ g:multi_cursor_next_key, g:multi_cursor_prev_key, g:multi_cursor_skip_key ],
      \ 'n': [ g:multi_cursor_next_key ],
      \ }
function! s:exit()
  if s:last_char() !=# g:multi_cursor_quit_key
    return 0
  endif
  let exit = 0
  if s:from_mode ==# 'n'
    let exit = 1
  elseif (s:from_mode ==# 'v' || s:from_mode ==# 'V') &&
        \ g:multi_cursor_exit_from_visual_mode
    let exit = 1
  elseif s:from_mode ==# 'i' && g:multi_cursor_exit_from_insert_mode
    stopinsert
    let exit = 1
  endif
  if exit
    call s:cm.reset(1, 1, 1)
    return 1
  endif
  return 0
endfunction
function! s:last_char()
  return s:char[len(s:char)-1]
endfunction
inoremap <silent> <Plug>(multiple-cursors-input) <C-o>:call Process_user_input()<CR>
nnoremap <silent> <Plug>(multiple-cursors-input) :call Process_user_input()<CR>
xnoremap <silent> <Plug>(multiple-cursors-input) :<C-u>call Process_user_input()<CR>

nmap <leader>n <Plug>(multiple-cursors-wait)

inoremap <silent> <Plug>(multiple-cursors-apply) <C-o>:call Apply_user_input_next('i')<CR>
nnoremap <silent> <Plug>(multiple-cursors-apply) :call Apply_user_input_next('n')<CR>
xnoremap <silent> <Plug>(multiple-cursors-apply) :<C-u>call Apply_user_input_next('v')<CR>

inoremap <silent> <Plug>(multiple-cursors-detect) <C-o>:call Detect_bad_input()<CR>
nnoremap <silent> <Plug>(multiple-cursors-detect) :call Detect_bad_input()<CR>
xnoremap <silent> <Plug>(multiple-cursors-detect) :<C-u>call Detect_bad_input()<CR>

inoremap <silent> <Plug>(multiple-cursors-wait) <C-o>:call Wait_for_user_input('')<CR>
nnoremap <silent> <Plug>(multiple-cursors-wait) :call Wait_for_user_input('')<CR>
xnoremap <silent> <Plug>(multiple-cursors-wait) :<C-u>call Wait_for_user_input('')<CR>

