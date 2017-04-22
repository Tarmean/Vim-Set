if (has('nvim'))
    silent! nnoremap ö :call TermOpen()<cr>
    silent! noremap Ö :call TermClose(0)<cr>
    silent! tnoremap Ö <C-\><C-n>:call TermClose(1)<cr>
    silent! tnoremap ö <C-\><C-n><c-w>p
    silent! tnoremap <esc> <C-\><C-n>
    func! TermOpen()
        if (&buftype == 'terminal')
            let g:cur_term = bufnr("")
            norm! i
        elseif (exists("g:cur_term")&&bufexists(g:cur_term))
            let wins = win_findbuf(g:cur_term)
            if (len(wins) > 0)
                call win_gotoid(wins[0])
                norm! i
            else
                vs
                exec "buf " . g:cur_term
                norm! i
            endif
        else
            vs
            term
            let g:cur_term = bufnr("$")
        endif
    endfunc
    func! TermClose(active)
        if (a:active)
            let active_win = winnr("#")
        else
            let active_win = winnr()
        endif
        let term_wins = win_findbuf(g:cur_term)
        for i in term_wins
            call win_gotoid(i)
            wincmd c
        endfor
        call win_gotoid(active_win)
    endfunc
endif

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
        for [l, r] in items(g:BracketSwapPairs) 
            silent! execute "iunmap " . l
        endfor
    endif
endfunction
call SetCharSwap(1)
nnoremap äoä :call SetCharSwap(0)<cr>
nnoremap üoü :call SetCharSwap(1)<cr>
silent! unmap [o
silent! unmap ]o

cnoremap %s/ %s/\v
cnoremap  w!! w !sudo tee % > /dev/null

nnoremap j gj
nnoremap k gk

nnoremap <silent> <esc> :noh<return><esc>
nnoremap <Leader>ö :w<CR>
noremap  <leader>ü :e $MYVIMRC<CR>
noremap  <leader>ä :so $MYVIMRC<CR>

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
nnoremap <Leader>yy "+yy
nnoremap <silent> <Leader>y :call Prep_yank('"+')<cr>g@
nnoremap <silent> <Leader>yy "+yy
nnoremap <silent> y :call Prep_yank('')<cr>g@
nnoremap <silent> yy yy
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P
nnoremap Y y$

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

nnoremap <leader>q :tab sp<CR>
nnoremap <leader>v <C-w>v
nnoremap <leader>V <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>C :bd!<CR> 

noremap <silent><leader>h  : call WinMove('h')<cr>
noremap <silent><leader>k  : call WinMove('k')<cr>
noremap <silent><leader>l  : call WinMove('l')<cr>
noremap <silent><leader>j  : call WinMove('j')<cr>
noremap <silent><leader>H  : wincmd H<cr>
noremap <silent><leader>K  : wincmd K<cr>
noremap <silent><leader>L  : wincmd L<cr>
noremap <silent><leader>J  : wincmd J<cr>
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

noremap <silent><leader>i gT
noremap <silent><space>o :exec "tabnext " . ((tabpagenr() + (v:count?v:count-1:0)) % (tabpagenr("$"))+1)<cr>
noremap <silent> <space>I :call TabCopy(1, tabpagenr()-1)<cr>
noremap <silent> <space>O :call TabCopy(1, tabpagenr()+1)<cr>
noremap <silent> <space><C-I> :call TabCopy(0, tabpagenr()-1)<cr>
noremap <silent> <space><C-O> :call TabCopy(0, tabpagenr()+1)<cr>
func! TabCopy(move, tab)
    let cur_buffer = bufnr('%')

    let tab_count = tabpagenr('$')
    let win_count = winnr("$")

    let target_tab = a:tab

    if a:move
        if win_count == 1 
            if tab_count == 1
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
silent noremap <silent><leader>a :call JumpToDef()<cr>zz:silent Pulse<cr>
silent noremap <silent><leader><s-a> <c-t>zMzvzz15<c-e>zz:silent Pulse<cr>
silent nmap <leader>s zz:silent Pulse<cr>
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

nnoremap <silent> g: :set opfunc=SourceVimscript<cr>g@
vnoremap <silent> g: :<c-U>call SourceVimscript("visual")<cr>
function! SourceVimscript(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @"
  if a:type == 'line'
    silent execute "normal! '[V']y"
  elseif a:type == 'char'
    silent execute "normal! `[v`]y"
  elseif a:type == "visual"
    silent execute "normal! gvy"
  elseif a:type == "currentline"
    silent execute "normal! yy"
  endif
  let @" = substitute(@", '\n\s*\\', '', 'g')
  " source the content
  @"
  let &selection = sel_save
  let @" = reg_save
endfunction
