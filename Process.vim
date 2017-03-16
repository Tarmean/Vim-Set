function! GetVisualText()
    let backupYank = getreg('0')
    norm! gvy
    let result = getreg('"')
    let results = ""
    for command in split(result, "\n")
        redir => output
        silent! execute "echo " . command
        silent! redir END
        let results = results .  output[1:-1]
    endfor
    call setreg('0', backupYank)
    call setreg('"', results, "l")
endfunction

nnoremap <silent><space>n V:call GetVisualText()<cr>
vmap <silent><space>n :call GetVisualText()<cr>

function! Log(a, b)
    return log(a:a) / log(a:b)
endfunction
function! Log2(a)
    return Log(a:a, 2)
endfunction

