
function! s:compare_pos(a, b)
    if a:a[1] < a:b[1]
        return -1
    elseif a:a[1] > a:b[1]
        return 1
    else
        return a:a[2] < a:b[2] ? -1 : a:a[2] == a:b[2] ? 0 : 1
    endif
endfunction


function! Test_op(type, ...)
    let s:left = getpos("'[")
    let s:right =getpos("']")
    let s:run = s:compare_pos(s:left, s:right) 
    let s:run = s:run == -1 ? 1 : 2
    if  s:initial
        call feedkeys(":call MapMotionCallback()\<cr>", "i")
    endif
endfunc
function! MapMotionSetup(op)
    let s:op = a:op ==# "g@" ? &opfunc: a:op
    let s:finish = 0
    let s:command = "|"
    set opfunc=Test_op
    let &selection = "exclusive"
    call MapMotionStart()
endfunction
function! MapMotionStart()
    let s:initial = 1
    let s:run = 0
    echo s:command
    let s:input = nr2char(getchar())
    if s:input == "\<esc>"
        call feedkeys(":call MapMotionFinish()\<cr>", "")
    else
        augroup OperatorCallback
            au!
            au CursorMoved * call MapMotionMotionFailedCheck()
        augroup END
        let s:command = s:command . " > " .s:input
        call feedkeys("qq:echo '".s:command."'\<cr>g@".s:input, "i")
    endif
endfunc
function! MapMotionCallback()
    redraw!
    let s:active_callback = 0
    call feedkeys("q", "inx")
    if s:run == 1
        " process
        let s:input .=  @q
        let s:command .=  @q
    else
        let s:command = s:command[0:-5]
    endif
    call feedkeys(":call MapMotionStart()\<cr>", "i")
endfunc
function! MapMotionFinish()
    let s:finish = 1
    echo s:command . "  finished"
endfunction
function! MapMotionMotionFailedCheck()
    augroup OperatorCallback
        au!
    augroup END
    if !s:run && !s:finish
        silent call MapMotionCallback()
    endif
endfunc


omap <silent> . <esc>:call MapMotionSetup(v:operator)<cr>



