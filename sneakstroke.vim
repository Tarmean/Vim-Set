function! VimSurround(dir)
    redraw | echo ">"
    let i = getchar()
    if nr2char(i) != " "
        let c = nr2char(i)
    else
    let c = ""
endif
    let active = 1
    while active
        sleep 6m
        let i = getchar(0)
        if i == 0
             break
        endif
        let c .= nr2char(i)
    endwhile
    call feedkeys(c)
    call sneak#wrap("", len(c), a:dir, 1, 0)
endfunction
imap <c-s> <c-o>:call VimSurround(0)<cr>
imap <c-d> <c-o>:call VimSurround(1)<cr>
