nnoremap <leader>q :tab sp<CR>
nnoremap <leader>e :redraw<CR>:ls<CR>

nnoremap <leader>i gT
nnoremap <leader>I :<C-U>call Clone_rel_tab_backwards(1, v:count)<CR>
nnoremap <leader><c-I> :<C-U>call Clone_rel_tab_backwards(0, v:count)<CR>
nnoremap <leader>O :<C-U>call Clone_rel_tab_forwards(1, v:count)<CR>
nnoremap <leader><c-O> :<C-U>call Clone_rel_tab_forwards(0, v:count)<CR>
nnoremap <silent><leader>o :<C-U>call RelativeNext(v:count1)<CR>
noremap <silent><leader>h  : call WinMove('h')<cr>
noremap <silent><leader>k  : call WinMove('k')<cr>
noremap <silent><leader>l  : call WinMove('l')<cr>
noremap <silent><leader>j  : call WinMove('j')<cr>
noremap <silent><leader>H  : wincmd H<cr>
noremap <silent><leader>K  : wincmd K<cr>
noremap <silent><leader>L  : wincmd L<cr>
noremap <silent><leader>J  : wincmd J<cr>

map <space><c-j> :SidewaysLeft<cr>
map <space><c-k> :SidewaysRight<cr>
map <space><c-h> :SidewaysJumpLeft<cr>
map <space><c-l> :SidewaysJumpRight<cr>

noremap [oI :set autoindent<cr>
noremap ]oI :set noautoindent<cr>
noremap ]oN :set foldcolumn=0<cr>
noremap [oN :set foldcolumn=4<cr>
noremap <silent> [oA :call SideLineToggle(1)<cr>
noremap <silent> ]oA :call SideLineToggle(0)<cr>

silent noremap <leader>a <c-]>zMzvzz15<c-e>:silent Pulse<cr>
silent noremap <leader><s-a> <c-t>zMzvzz15<c-e>:silent Pulse<cr>
silent nmap <leader>s zMzvzz15<c-e>:silent Pulse<cr>
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
