
noremap ]oV :IndentGuidesDisable<cr>
noremap [oV :IndentGuidesEnable<cr>

nnoremap <leader>u :GundoToggle<CR>

vnoremap <leader>r :<c-u>execute ":'<,'>Tabular /"nr2char(getchar())<cr>
vnoremap <leader>R :Tabular<space>/

let g:tagbar_left=1
let g:tagbar_autoclose=0
let g:tagbar_autofocus=1
let g:tagbar_iconchars = ['▶', '▼']
nnoremap <leader>a :Tagbar<cr>
noremap ]oa :TagbarTogglePause<cr>
noremap [oa :TagbarGetTypeConfig<cr>

if(has('nvim'))
    nnoremap <silent> <leader><leader> :execute "Locate " . expand("~")<cr>
    command! -nargs=1 Locate call fzf#run(
                \ {'source': 'locate <q-args>', 'sink': 'e', 'options': '-m'})

    function! s:buflist()
        redir => ls
        silent ls
        redir END
        return split(ls, '\n')
    endfunction

    function! s:bufopen(e)
        execute 'buffer' matchstr(a:e, '^[ 0-9]*')
    endfunction

    nnoremap <silent> <Leader><Enter> :call fzf#run({
                \   'source':  reverse(<sid>buflist()),
                \   'sink':    function('<sid>bufopen'),
                \   'options': ' +m',
                \   'down':    len(<sid>buflist()) + 2
                \ })<CR>


    nnoremap <silent> <Leader>fs :FZFMru<cr>
    command! FZFMru call fzf#run({
                \'source': v:oldfiles,
                \'sink' : 'e ',
                \'options' : ' -m -x',
                \})



    nnoremap <silent> <Leader>ft :FZFTag<cr>
    command! FZFTag if !empty(tagfiles()) | call fzf#run({
                \   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
                \   'sink':   'tag',
                \ }) | else | echo 'No tags' | endif

    function! s:line_handler(l)
        let keys = split(a:l, ':\t')
        exec 'buf ' . keys[0]
        exec keys[1]
        normal! ^zz
    endfunction

    function! s:buffer_lines()
        let res = []
        for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
            call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
        endfor
        return res
    endfunction
    function! s:cur_buffer_lines()
        let res = []
        let l:b = bufnr('%')
        call extend(res, map(getbufline(l:b,0,"$"), 'l:b . ":\t" . (v:key + 1) . ":\t" . v:val '))
        return res
    endfunction
    nnoremap <silent> <Leader>fL :FZFLines<cr>
    command! FZFLines call fzf#run({
                \   'source':  <sid>buffer_lines(),
                \   'sink':    function('<sid>line_handler'),
                \   'options': '--extended --nth=3..',
                \})

    nnoremap <silent> <Leader>fl :FZFCurLines<cr>
    command! FZFCurLines call fzf#run({
                \   'source':  <sid>cur_buffer_lines(),
                \   'sink':    function('<sid>line_handler'),
                \   'options': '--extended --nth=3..',
                \})

    function! s:ag_handler(lines)
        if len(a:lines) < 2 | return | endif

        let [key, line] = a:lines[0:1]
        let [file, line, col] = split(line, ':')[0:2]
        let cmd = get({'ctrl-x': 'split', 'ctrl-v': 'vertical split', 'ctrl-t': 'tabe'}, key, 'e')
        execute cmd escape(file, ' %#\')
        execute line
        execute 'normal!' col.'|'
    endfunction

    command! -nargs=1 Ag call fzf#run({
                \ 'source':  'ag --nogroup --column --color "'.escape(<q-args>, '"\').'"',
                \ 'sink*':    function('<sid>ag_handler'),
                \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --no-multi',
                \ 'down':    '50%'
                \ })


else
    "let g:unite_source_history_yank_enable = 1
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    "let g:unite_source_rec_async_command =
                \ 'ag --follow --nocolor --nogroup --hidden -g ""'
    nnoremap <leader>fJ :Unite -buffer-name=files   -start-insert file_rec:!<cr>
    nnoremap <leader>fj :<C-u>Unite -buffer-name=files   -start-insert file<cr>
    nnoremap <leader>fs :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
    nnoremap <leader>fk :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
    nnoremap <leader>fy :<C-u>Unite -buffer-name=yank    history/yank<cr>
    nnoremap <leader>ff :<C-u>Unite -buffer-name=buffer  buffer<cr>
    nnoremap <leader>fl :<C-u>Unite -buffer-name=buffer -start-insert -no-split line<cr>
    autocmd FileType unite call s:unite_settings()
    function! s:unite_settings()
        let b:SuperTabDisabled=1
        imap <buffer> <C-j>   <Plug>(unite_select_next_line)
        imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
        nmap <buffer> <esc>   <Plug>(unite_exit)
        map <buffer> <leader><c>   <Plug>(unite_exit)
    endfunction
endif


noremap ]oc :call SetJavaComplete(0)<cr>
noremap [oc :call SetJavaComplete(1)<cr>
function! SetJavaComplete(bool)
    augroup JavaComplete
        au!
        if(a:bool)
            au FileType java exec "setlocal omnifunc=javacomplete#Complete"
            au FileType java exec "setlocal completefunc=javacomplete#CompleteParamsInfo"
            if(&ft=="java")
                setlocal omnifunc=javacomplete#Complete
                setlocal completefunc=javacomplete#CompleteParamsInfo
            endif
        else
            set omnifunc=
            set completefunc=
        endif
    augroup END
endfunction


function! SignifyUpdate(b)
    if(a:b)
        let g:signify_cursorhold_insert=1
        let g:signify_cursorhold_normal=1
        let g:signify_update_on_bufenter=1
        let g:signify_update_on_focusgained=1
        call SignifyAutocommands()
        return
    endif
    let g:signify_cursorhold_insert=0
    let g:signify_cursorhold_normal=0
    let g:signify_update_on_bufenter=0
    let g:signify_update_on_focusgained=0
    call SignifyAutocommands()
    return
endfunction
noremap [og :call SignifyUpdate(1)<cr>
noremap ]og :call SignifyUpdate(0)<cr>
noremap [oG :SignifyToggle<cr>
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)
noremap ]oG :SignifyToggleHighlight<cr>
let g:signify_vcs_list = ['git']
"noremap [oG :GitGutterEnable<cr>
"noremap ]oG :GitGutterDisable<cr>
"noremap [og :GitGutterEager<cr>
"noremap ]og :GitGutterLazy<cr>
"noremap ]og :GitGutterLazy<cr>
