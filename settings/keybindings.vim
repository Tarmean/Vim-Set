nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround
autocmd FileType c nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<cr>

let g:BracketSwapPairs = {
            \'ä': '{',
            \'Ä': '}',
            \'ö': '(',
            \'Ö': ')',
            \'ü': '[',
            \'Ü': ']',
        \}


function! SetCharSwap(bool)
    if(a:bool)
        for [l, r] in items(g:BracketSwapPairs)
            silent! execute "imap " . l . " " . r
        endfor
    else
        for [l, r] in items(g:BracketSwapPairs) " i know what keys does but then it wouldn't be symmetric :O
            silent! execute "iunmap " . l
        endfor
    endif
endfunction
call SetCharSwap(1)





cnoremap %s/ %s/\v
cnoremap  w!! w !sudo tee % > /dev/null

nnoremap j gj
nnoremap k gk

nnoremap <silent> <esc> :noh<return><esc>
nnoremap <Leader>ö :w<CR>
noremap  <leader>ü :e $MYVIMRC<CR>
noremap  <leader>ä :so $MYVIMRC<CR>
map ü [
map ä ]
map Ä }
map Ü {

    " if maparg("<cr>", "n") == ""
    "   nnoremap <cr> :
    " endif

nnoremap <cr> :
vnoremap <cr> :
nnoremap / /\v




noremap H ^
noremap L $
nnoremap gI `.

nnoremap <Leader>e :cd %:h\|execute "term"\|cd -<cr>

nnoremap =<space>p "+]p=']
nnoremap =<space>P "+[p=']
vnoremap <Leader>y "+y
nnoremap <silent> <Leader>y :call Prep_yank('"+')<cr>g@
nnoremap <silent> <Leader>yy "+yy
nnoremap <silent> y :call Prep_yank('')<cr>g@
nnoremap <silent> yy yy
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

func! Prep_yank(reg)
    let g:preyankpos = winsaveview()
    let g:yankreg = a:reg
    set opfunc=Yank
endfunc
func! Yank(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"

    if a:type == 'line' 
      silent exe "normal! '[V']".g:yankreg."y"
    else
      silent exe "normal! `[v`]".g:yankreg."y"
    endif
    call winrestview(g:preyankpos)

	let &selection = sel_save
endfunc

nnoremap Y y$

nnoremap <leader>q :tab sp<CR>

noremap <silent><leader>i gT
noremap <silent><space>o :exec "tabnext " . ((tabpagenr() + (v:count?v:count-1:0)) % (tabpagenr("$"))+1)<cr>

noremap <silent><leader>h  : call WinMove('h')<cr>
noremap <silent><leader>k  : call WinMove('k')<cr>
noremap <silent><leader>l  : call WinMove('l')<cr>
noremap <silent><leader>j  : call WinMove('j')<cr>
noremap <silent><leader>H  : wincmd H<cr>
noremap <silent><leader>K  : wincmd K<cr>
noremap <silent><leader>L  : wincmd L<cr>
noremap <silent><leader>J  : wincmd J<cr>

nnoremap <leader>v <C-w>v
nnoremap <leader>V <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>C :bd!<CR> 

noremap [oI :set autoindent<cr>
noremap ]oI :set noautoindent<cr>
noremap ]oN :set foldcolumn=0<cr>
noremap [oN :set foldcolumn=4<cr>
noremap <silent> [oA :call SideLineToggle(1)<cr>
noremap <silent> ]oA :call SideLineToggle(0)<cr>

fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf
silent noremap <silent><leader>a :call JumpToDef()<cr>zMzvzz15<c-e>:silent Pulse<cr>
silent noremap <silent><leader><s-a> <c-t>zMzvzz15<c-e>:silent Pulse<cr>
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

cabbrev git Git
nnoremap <space>ga :execute 'Git add ' . expand('%:p')<CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q %:p<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
noremap <space>gf :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gb :Git branch<Space>
nnoremap <space>gB :Gblame<CR>
vnoremap dp :diffput<cr>
vnoremap do :diffget<cr>

nnoremap <leader>gV :Gitv --all<cr>
nnoremap <leader>gv :Gitv! --all<cr>
vnoremap <leader>gv :Gitv! --all<cr>

vmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(LiveEasyAlign)
vmap <leader>r <Plug>(LiveEasyAlign)

func! TabCopy(move, tab)
    let cur_buffer = bufnr('%')

    let tab_count = tabpagenr('$')
    let win_count = winnr("$")

    let target_tab = a:tab

    if a:move
        if win_count == 1 
            if tab_count == 1  " closing the tab would fail and would be pointless anyway
                return
            endif

            if target_tab > tabpagenr()
                let target_tab -= 1 
            endif
        endif

        wincmd c
    endif


    if target_tab <= 0 || target_tab > tab_count
        silent! exe target_tab . "tab sb" . cur_buffer
    else
        silent! exe target_tab . "tabn"
        silent! vs|wincmd H
        silent! exe "b " . cur_buffer
    endif
endfunc
noremap <silent> <space>I :call TabCopy(1, tabpagenr()-1)<cr>
noremap <silent> <space>O :call TabCopy(1, tabpagenr()+1)<cr>
noremap <silent> <space><C-I> :call TabCopy(0, tabpagenr()-1)<cr>
noremap <silent> <space><C-O> :call TabCopy(0, tabpagenr()+1)<cr>


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
