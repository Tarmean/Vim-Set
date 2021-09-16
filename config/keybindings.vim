let mapleader = "\<space>"
let maplocalleader = ","

auto Filetype clojure nmap cii yaf]][[%opc!!
auto Filetype clojure nmap K <Plug>FireplaceK

map <f1> <esc>
tnoremap <s-space> <space>
nnoremap <up> <c-w>-
nnoremap <down> <c-w>+
nnoremap <left> <c-w><
nnoremap <right> <c-w>>
nnoremap <a-h> 20zh
nnoremap <a-l> 20zl
nnoremap <a-j> 8<c-e>
nnoremap <a-k> 8<c-y>

tnoremap <c-v> <c-\><c-n>"+pi


silent! unmap [o
silent! unmap ]o
nmap ü [
nmap + ]

if (has('vim') || has ('nvim'))
    cnoremap %s/ %s/\v
    cnoremap  w!! w !sudo tee % > /dev/null
endif

nnoremap j gj
nnoremap k gk

nnoremap <silent> <esc> :call coc#float#close_all()<cr>:noh<return><esc>
nnoremap <Leader>ö :w<CR>
noremap  <leader>ü :e $MYVIMRC<CR>
noremap  <leader>ä :so $MYVIMRC<CR>

nnoremap <cr> :
vnoremap <cr> :
nnoremap / /\v

noremap H ^
noremap L $
nnoremap gI `.


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
    elseif a:type == 'block'
      silent exe "normal! '[']".g:yankreg."y"
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
    let t:curwin = win_getid()
    exec "wincmd ".a:key
    if (t:curwin == win_getid())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

noremap <silent><leader>i gT
noremap <silent> <space>o :exec "tabnext " . ((tabpagenr() + (v:count?v:count-1:0)) % (tabpagenr("$"))+1)<cr>
noremap <silent> <space>I :call TabCopy(1, -1)<cr>
noremap <silent> <space>O :call TabCopy(1, +1)<cr>
noremap <silent> <space><C-I> :call TabCopy(0, -1)<cr>
noremap <silent> <space><C-O> :call TabCopy(0, +1)<cr>
nnoremap <silent> <space>Q :call MoveTabNew()<cr>
func! MoveTabNew()
    if (winnr("$") == 1)
        return
    endif
    let l:buf = bufnr('%')
    wincmd c
    exec "tab sb" . l:buf
endfunc
func! TabCopy(move, dir)
    let l:cur_buffer = bufnr('%')

    let l:tab_count = tabpagenr('$')
    let l:win_count = winnr("$")
    let l:cur_tab = tabpagenr()


    if l:cur_tab == 1 && a:dir == -1
        let l:mode = "new_tab_left"
    elseif l:cur_tab == l:tab_count && a:dir == 1
        let l:mode = "new_tab_right"
    else
        let l:mode = "reuse_tab"
    endif

    if a:move
        if l:win_count == 1
            if l:mode != "reuse_tab"
                return
            endif
            let l:cur_tab -= a:dir
        endif
        wincmd c
    endif

    if l:mode == "new_tab_left"
        exe "0tab sb" . l:cur_buffer
    elseif mode == "new_tab_right"
        exe "tab sb" . l:cur_buffer
    else
        silent! exe (l:cur_tab + a:dir) . "tabn"
        silent! exe "sb" . l:cur_buffer
        wincmd H
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
fun! DoAg(pat, args)
    if a:args
        call fzf#vim#ag(a:pat)
    else
        call Git_dir("call fzf#vim#ag('" .a:pat."',".a:args.')') 
    endif
endfun
command!      -bang -nargs=* Ag  call DoAg(<q-args>, <bang>0)
" command!      -bang -nargs=* Agl  call fzf#vim#ag(<q-args>, <bang>0)
nnoremap <silent> <leader>a :ArgWrap<CR>
function! Pulse() " {{{
    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')


    hi CursorLine guibg=#1c1c1c
    let l:old_cursorline = &cursorline
    set cursorline
    redraw
    sleep 80m
    let &cursorline = l:old_cursorline
    execute 'hi ' . old_hi
endfunction " }}}
command! -nargs=0 Pulse call Pulse()

function! s:delete_hidden_buffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
command! ClearHiddenBufs call s:delete_hidden_buffers()
nnoremap <leader>b :ClearHiddenBufs<cr>

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


function! OnBuffEnter()
  let l:new_buf = bufnr()
  if (exists("g:last_buffer"))
    execute g:last_buf . "b"
    diffoff
    execute l:new_buf . "b"
  endif
  let g:last_buf = l:new_buf
  if (exists("g:diff_buf"))
      exec g:diff_buf."bw"
  endif
  vert new | diffthis | set buftype=nofile|read ++edit # | 0d_
  let g:diff_buf = bufnr()
  wincmd p
  diffthis
endfunction
augroup diffing
  au!
  " au BufEnter * call OnBuffEnter()
  " au BufWritePost * call OnBuffEnter()
augroup END
