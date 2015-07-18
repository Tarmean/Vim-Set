nnoremap <silent> <leader>d :call InterestingWords('n')<cr>
nnoremap <silent> <leader>D :call UncolorAllWords()<cr>
let g:interestingWordsGUIColors = ['#FFF6CC', '#FFD65C', '#8CCBEA', '#A4E57E', '#99FFE6', '#E6FF99', '#FFDB72', '#5CD6FF', '#99FFB3', '#FF7272', '#99FF99', '#99B3FF', '#FFB399']
"let g:easytags_async=1
let g:easytags_dynamic_files=1
noremap  ]oH unlet g:easytags_auto_highlight
noremap [oH let g:easytags_auto_highlight=1

let g:textobj_comment_no_default_key_mappings = 1
xmap aX <Plug>(textobj-comment-big-a)
xmap ax <Plug>(textobj-comment-a)
omap ax <Plug>(textobj-comment-a)
xmap ix <Plug>(textobj-comment-i)
omap ix <Plug>(textobj-comment-i)

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

let g:sneak#streak=1
silent! unmap s
silent! unmap S
let g:sneak#s_next=1
let g:sneak#textobj_z=0
let g:sneak#use_ic_scs = 1
nmap f <Plug>Sneak_f
lmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
nmap ö <Plug>Sneak_s
nmap Ö <Plug>Sneak_S
" visual-mode
xmap ö <Plug>Sneak_s
xmap Ö <Plug>Sneak_S
" operator-pending-mode
omap ö <Plug>Sneak_s
omap Ö <Plug>Sneak_S

noremap ]oL :RainbowToggle<cr>

vmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(LiveEasyAlign)
vmap <leader>r <Plug>(LiveEasyAlign)

" autocmd VimEnter * call after_object#enable('=')



let g:indentLine_char = '︙'
let g:indentLine_enabled = 0
noremap [oL :IndentLinesToggle<cr>
set list lcs+=tab:\|\ 
set nolist
nnoremap <leader>u :GundoToggle<CR>


"let g:tagbar_left=1
"let g:tagbar_autoclose=0
"let g:tagbar_autofocus=1
"let g:tagbar_iconchars = ['▶', '▼']
"nnoremap <leader>a :Tagbar<cr>
"noremap ]oa :TagbarTogglePause<cr>
"noremap [oa :TagbarGetTypeConfig<cr>


noremap ]oz :Goyo!<cr>
noremap [oz :Goyo<cr>:IndentLinesDisable<cr>


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



    nnoremap <silent> <Leader>fD :call FZFAllTags()<cr>
    nnoremap <silent> <Leader>fd :call FZFTag()<cr>
    function! FZFAllTags() 
        if !empty(tagfiles()) 
            call fzf#run({
                    \   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
                    \   'sink':   'tag',
                    \ }) 
        else 
            echo 'No tags' 
        endif
    endfunction

    function! FZFTags() 
        if !empty(tagfiles()) 
            call fzf#run({
                    \   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
                    \   'sink':   'tag',
                    \ }) 
        else 
            echo 'No tags' 
        endif
    endfunction

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

    cnoremap <silent> <c-l> <c-r>=GetCompletions()<cr>
    "add an extra <cr> at the end of this line to automatically accept the fzf-selected completions.

    function! Lister()
        call extend(g:FZF_Cmd_Completion_Pre_List,split(getcmdline(),'\(\\\zs\)\@<!\& '))
    endfunction

    function! CmdLineDirComplete(prefix, options, rawdir)
        let l:dirprefix = matchstr(a:rawdir,"^.*/")
        if isdirectory(expand(l:dirprefix))
            return join(a:prefix + map(fzf#run({
                        \'options': a:options . ' --select-1  --query=' .
                        \ a:rawdir[matchend(a:rawdir,"^.*/"):len(a:rawdir)], 
                        \'dir': expand(l:dirprefix)
                        \}), 
                        \'"' . escape(l:dirprefix, " ") . '" . escape(v:val, " ")'))
        else
            return join(a:prefix + map(fzf#run({
                        \'options': a:options . ' --query='. a:rawdir }),
                        \'escape(v:val, " ")')) 
            "dropped --select-1 to speed things up on a long query
        endif
    endfunction

    function! GetCompletions()
        let g:FZF_Cmd_Completion_Pre_List = []
        let l:cmdline_list = split(getcmdline(), '\(\\\zs\)\@<!\& ', 1)
        let l:Prefix = l:cmdline_list[0:-2]
        execute "silent normal! :" . getcmdline() . "\<c-a>\<c-\>eLister()\<cr>\<c-c>"
        let l:FZF_Cmd_Completion_List = g:FZF_Cmd_Completion_Pre_List[len(l:Prefix):-1]
        unlet g:FZF_Cmd_Completion_Pre_List
        echom l:cmdline_list[-1]
        if len(l:Prefix) > 0 && l:Prefix[0] =~
                    \ '^ed\=i\=t\=$\|^spl\=i\=t\=$\|^tabed\=i\=t\=$\|^arged\=i\=t\=$\|^vsp\=l\=i\=t\=$'
            "single-argument file commands
            return CmdLineDirComplete(l:Prefix, "",l:cmdline_list[-1])
        elseif len(l:Prefix) > 0 && l:Prefix[0] =~ 
                    \ '^arg\=s\=$\|^ne\=x\=t\=$\|^sne\=x\=t\=$\|^argad\=d\=$'  
            "multi-argument file commands
            return CmdLineDirComplete(l:Prefix, '--multi', l:cmdline_list[-1])
        endif 
        return join(l:Prefix + fzf#run({
                    \'source':l:FZF_Cmd_Completion_List, 
                    \'options': '--select-1 --query=' . l:cmdline_list[-1]
                    \})) 
    endfunction


    nnoremap <silent> <Leader>fc :call fzf#run({
                \   'source':
                \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
                \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
                \   'sink':    'colo',
                \   'options': '+m',
                \   'left':    30
                \ })<CR>

    command! -bar FZFTags if !empty(tagfiles()) | call fzf#run({
                \   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
                \   'sink':   'tag',
                \ }) | else | echo 'Preparing tags' | call system('ctags -R') | FZFTag | endif
    noremap <leader>fd :FZFTags<cr>
else
    "let g:unite_source_history_yank_enable = 1
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    "let g:unite_source_rec_async_command =
                \ 'ag --follow --nocolor --nogroup --hidden -g ""'
    nnoremap <leader>fJ :Unite -buffer-name=files   -start-insert file_rec:!<cr>
    nnoremap <leader>fj :<C-u>Unite -buffer-name=files   -start-insert file<cr>
    nnoremap <leader>fs :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
    nnoremap <leader>fd :<C-u>Unite -buffer-name=tags     -start-insert tag<cr>
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
let g:JavaComplete_Home = $HOME . '/vimfiles/plugged/vim-javacomplete2'
let $CLASSPATH .= '.:' . $HOME . '/vimfiles/plugged/vim-javacomplete2/libs/javavi/target/classes'
let g:JavaComplete_SourcePath = $HOME . '/teamf3/*.jar:' . $HOME . '/teamf3/src/**/*.java'
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
"noremap [og :GitGutterEaer<cr>
"noremap ]og :GitGutterLazy<cr>
"noremap ]og :GitGutterLazy<cr>
"
"
