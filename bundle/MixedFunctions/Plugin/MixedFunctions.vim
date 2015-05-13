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

        let g:delimitMate_matchpairs = "(:),[:],{:},<:>,ö:),ü:],ä:}"
        silent exec "DelimitMateReload"
        "inoremap { Ü
        "inoremap } Ä
        "inoremap [ ü
        "inoremap ] ä
        "inoremap ) Ö
        "inoremap ( ö
    else
        let g:delimitMate_matchpairs = "(:),[:],{:},<:>"
        silent exec "DelimitMateReload"
        "iunmap {
        "iunmap }
        "iunmap [
        "iunmap ]
        "iunmap (
        "iunmap )
    endif
    silent exec "DelimitMateReload"
endfunction
call SetCharSwap(1)
command!  -narg=1 SetCharSwap call SetCharSwap(<args>)

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
"call SideLineToggle(1)

function! WhitespaceSpaces()
    silent! %s/\v\s+$//
    silent! %s/	/    /
endfunction
map <leader>z :call WhitespaceSpaces()<cr>

function! ConvertBasesUnderCursor(from, too)
    norm "iyiw
    let @i = ConvertBases(@i,  a:from, a:too )
    norm viw"_"ip
endfunction

command! -bar -nargs=+ C call ConvertBasesUnderCursor(<f-args>)

let g:runRunning = 0
function! RunStartOrToggle() range
    if(!g:runRunning)
        let g:runCurrentLine = a:firstline
        let g:runFinalLine = a:lastline
        let g:runFirstLine = a:firstline
        call inputsave()
        let l:runInputPattern = input("Pattern: ")
        let l:runInputCommand = input("Command: ")
        if(l:runInputPattern!="")
            let g:runPattern = l:runInputPattern
        endif
        if(l:runInputCommand!="")
            let g:runCommand = l:runInputCommand
        endif
        call inputrestore()
        let g:runRunning = 1
        let g:runContinuos = 0
        call s:runStart()
    elseif(g:runCurrentState!="Interrupted")
        let g:runCurrentState = "Interrupted"
    else
        let g:runCurrentState = "ContinueLine"
        call s:runContinueLine()
    endif

endfunction

function! Temp()
    let g:runPattern = input("pattern: ")
endfunction

function! RunStartContinuos(...) range
    if(a:0>1)
        let g:runPattern = a:1
        let g:runCommand = a:2

        let l:i = 2
        while(l:i<a:0)
            let g:runCommand = g:runCommand . " ". a:000[i]
            let l:i += 1
        endwhile
    endif
    let g:runContinuos = 1
    let g:runCurrentLine = a:firstline
    let g:runFinalLine = a:lastline
    let g:runFirstLine = a:firstline
    call s:runStart()
endfunction

function! s:runStart()
    echom "Command " . g:runCommand
    let g:runCurrentState = "ContinueLine"

    call s:runContinueLine()
    call setpos("'<", [0, g:runFirstLine, 1])
    call setpos("'>", [0, g:runFinalLine, 99])
endfunction

function! s:runContinueLine()
    echom "enter NextLine"
    if(g:runCurrentState=="Interrupted")
        exec g:runCurrentLine . "call s:continueSubLine()"
        let g:runCurrentOccurence = 1
        let g:runCurrentLine += 1
        if(g:runCurrentLine>=g:runFinalLine)
            let g:runCurrentState = "None"
        endif
    endif
    while(g:runCurrentState == "ContinueLine")
        echom "Line " . g:runCurrentLine . "/" . g:runFinalLine
        if(search(g:runPattern, "cn", g:runCurrentLine)!=0)
            let g:runCurrentOccurence = 1
            redir => l:occurenceString
            exec g:runCurrentLine . "s/" . g:runPattern . "//n"
            redir END
            let g:runOccurencesInLine = l:occurenceString[1]
            let g:runCurrentState = "SubLine"
            exec g:runCurrentLine . "call s:continueSubLine()"
        endif
        let g:runCurrentLine += 1
        if(g:runCurrentLine>=g:runFinalLine)
            let g:runCurrentState = "None"
        endif
    endwhile
    echom "Leave NextLine"
    let g:runRunning = ""
endfunction

function! s:continueSubLine()
    echom "enter SubLine"
    if(g:runCurrentState=="Interrupted")
        call s:splitCommand()
        call search(g:runPattern, "ce", line("."))
        if(g:runCurrentOccurence==g:runOccurencesInLine)
            let g:runCurrentState = "ContinueLine"
        endif
        let g:runCurrentOccurence +=1
    endif
    while(g:runCurrentState=="SubLine")
        echom "Occurence " . (g:runCurrentOccurence) . "/" . g:runOccurencesInLine
        exec "norm " . g:runColumn . "|w"
        call search(g:runPattern, "c", line("."))
        let g:runColumn = virtcol(".")
        let g:runCurrentState = "SubCommand"
        if(g:runContinuos)
            call s:continuousCommand()
        else
            let g:runCurrentSplitExec = 0
            call s:splitCommand()
        endif
        if(g:runCurrentOccurence==g:runOccurencesInLine)
            let g:runCurrentState = "ContinueLine"
        endif
        let g:runCurrentOccurence +=1
    endwhile
    echom "Leave SubLine"
endfunction

function! s:continuousCommand()
    echom "Execute Command " . g:runCommand
    exec "norm " . g:runCommand
    exec "norm " . g:runColumn . "|w"
           let g:runCurrentState = "SubLine"
endfunction

function! s:splitCommand()
    echom "Execute Split " . g:runCommand . ", Line: " . line(".")
    call feedkeys("")
    for l:char in split(g:runCommand, '\zs')
        echom l:char . ", Pos: " . virtcol("."). ", Line: " . line(".") . ", saved: " . g:runColumn
        call feedkeys(l:char)
        sleep 200 m
    endfor
           let g:runCurrentState = "SubLine"
endfunction





function! ApplyPattern(pattern, command, ...)
    if(a:0>1)
        let l:doRepeat=a:1
    else
        let l:doRepeat=1
    endif
    if(search(a:pattern, "cn", line("."))==0)
        return -1
    else
        if(l:doRepeat)
            redir => l:occurenceString
            exec "s/" . a:pattern . "//n"
            redir END
            let l:Occurences = l:occurenceString[1]
        else
            let l:Occurences = 1
        endif
        for i in range(l:Occurences)
            call search(a:pattern, "ce", line("."))
            let l:column = virtcol(".")
            exec "norm b" . a:command
            exec "norm " . l:column . "|w"
        endfor
    endif
endfunction

command! -nargs=+ -range -bar R
    \ :<line1>,<line2>call ApplyPattern(<f-args>)
command! -range -bar RunToggle :<line1>,<line2>call RunStartOrToggle()
map Q :RunToggle<cr>
