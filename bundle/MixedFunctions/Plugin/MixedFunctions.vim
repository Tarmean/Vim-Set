function! RelativeNext(count)

    let total_tabs = tabpagenr("$")

    let cur_tab = tabpagenr()

    let next_tab = (cur_tab + a:count -1) % total_tabs + 1

    exec "tabnext" .  next_tab

endfunction
command! -count=1 TabNext call RelativeNext(<count>)
command! -count JumpBackward norm! <count><C-O>
command! -count JumpForward norm! <count><C-i>


"totes stole this from ctrlspace. Sorry, but not keeping the entire thing for one feature :P
function! Copy_or_move_selected_buffer_into_tab(move, tab)
"this should work vor the current buffer
  let l:cur_buffer = bufnr('%')
  let l:total_tabs = tabpagenr('$')
  "if the new tab has the current buffer in a different view that one would be
  "used once the buffer gets reopened. there is probably some way it's
  "supposed to be done but yay workarounds
  let l:winview = winsaveview()
"not sure if these are all necessary but better save than sorry I guess
      if !getbufvar(str2nr(l:cur_buffer), '&modifiable') || !getbufvar(str2nr(l:cur_buffer), '&buflisted') || empty(bufname(str2nr(l:cur_buffer))) || (a:tab == tabpagenr() && a:move == 1)
    return
  endif
  let l:selected_buffer_window = bufwinnr(l:cur_buffer)
  if a:move > 0
        if selected_buffer_window != -1
      if bufexists(l:cur_buffer) && (!empty(getbufvar(l:cur_buffer, "&buftype")) || filereadable(bufname(l:cur_buffer)))
        silent! exe l:selected_buffer_window . "wincmd c"
      else
        return
      endif
    endif
  endif
  if a:tab  > l:total_tabs || a:tab == 0
    "let l:total_tabs = (l:total_tabs + 1)
    silent! exe a:tab . "tab  sb" . l:cur_buffer
  else
    if (a:move == 2 || a:move == -1) && a:tab == 0
      silent! exe "normal! gT"
    else
      silent! exe "normal! " . a:tab . "gt"
    endif
    silent! exe ":vert sbuffer " . l:cur_buffer
  endif
  call winrestview(l:winview)
endfunction
function! Clone_rel_tab_forwards(move, ...)
  let l:distance = (a:0>0 && a:1>0) ? a:1 : 1
  let l:cur_tab = tabpagenr()
  let l:goal_tab = (l:cur_tab + l:distance)
  call Copy_or_move_selected_buffer_into_tab(a:move, l:goal_tab)
endfunction

function! Clone_rel_tab_backwards(move, ...)
  let l:distance = (a:0>0 && a:1>0) ? a:1 : 1
  let l:cur_tab = tabpagenr()
  let l:goal_tab = (l:cur_tab - l:distance)
  call Copy_or_move_selected_buffer_into_tab(a:move, l:goal_tab)
endfunction

command!  -narg=* CloneToTab exec Copy_or_move_selected_buffer_into_tab(<args>)



function! SetCharSwap(bool)
	if(a:bool)
		inoremap ü [
		inoremap ä ]
		inoremap Ü {
		inoremap Ä }
		inoremap { Ü
		inoremap } Ä
		inoremap [ ü
		inoremap ] ä
	else
		iunmap ü
		iunmap ä
		iunmap Ü
		iunmap Ä
		iunmap {
		iunmap }
		iunmap [
		iunmap ]
	endif
endfunction
execute SetCharSwap(1)
command!  -narg=1 SetCharSwap exec SetCharSwap(<args>)

"move windows around:
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr()) "we havent moved
    if (match(a:key,'[jk]')) "were we going up/down
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

function! s:CreateSession(name)
  exec "Obsession ~/.vim/session/" . a:name . ".vim"
endfunction

command! -bar -nargs=1 Createsession call s:CreateSession(<q-args>)

function! SideLineToggle(bool)
	if(a:bool)
		augroup sideLine
			au!
			autocmd WinLeave * if index(numBlacklist, &ft) < 0 | setlocal nornu nocursorline
			autocmd WinEnter * if index(numBlacklist, &ft) < 0 | setlocal rnu cursorline
		augroup END
		let g:SideLine=1
		setlocal rnu cursorline
	elseif(g:SideLine)
		augroup sideLine
			au!
		augroup END
		autocmd! sideLine
		let g:SideLine=0
		setlocal nornu nocursorline
	endif
endfunction
call SideLineToggle(1)
