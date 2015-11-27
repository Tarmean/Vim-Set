nnoremap <leader>q :tab sp<CR>
nnoremap <leader>e :redraw<CR>:ls<CR>


noremap <leader>a <c-]>mzzMzvzz15<c-e>`z:Pulse<cr>
noremap <leader><s-a> <c-t>mzzMzvzz15<c-e>`z:Pulse<cr>

nnoremap Q q:


"session stuff, probably managed by obsession
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

"F2 for paste mode so pasted stuff isn't indented
set pastetoggle=<F2>

"F11 show current buffer in the explorer
nmap <F11> :!start explorer /e,/select,%:p<CR>
imap <F11> <Esc><F11>




nmap <leader>s mzzMzvzz15<c-e>`z:Pulse<cr>
function! s:Pulse() " {{{
    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    hi CursorLine guibg=#1c1c1c
    redraw
    sleep 80m
    execute 'hi ' . old_hi
endfunction " }}}
command! -nargs=0 Pulse call s:Pulse()
function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()
" Visual Mode */# from Scrooloose {{{

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction


