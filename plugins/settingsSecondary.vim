nnoremap <F4> call javacomplete#AddImport()<cr>
autocmd FileType java set omnifunc=javacomplete#Complete
let JavaComplete_LibsPath = "/home/cyril/teamf3/"

let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
            \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
"function! g:UltiSnips_Complete()
"    call UltiSnips#ExpandSnippet()
"    if g:ulti_expand_res == 0
"        if pumvisible()
"            return "\<C-n>"
"        else
"            call UltiSnips#JumpForwards()
"            if g:ulti_jump_forwards_res == 0
"                return "\<tab>"
"            endif
"        endif
"    endif
"    return ""
"endfunction
"au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
"let g:UltiSnipsListSnippets="<c-e>"
"" this mapping Enter key to <C-y> to chose the current highlight item 
"" and close the selection list, same as other IDEs.
"" CONFLICT with some plugins like tpope/Endwise
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
 
if(has("unix"))
    let g:easytags_async=1
endif
let g:easytags_dynamic_files=1
noremap  ]oH unlet g:easytags_auto_highlight
noremap [oH let g:easytags_auto_highlight=1

nnoremap <silent> <leader>d :call InterestingWords('n')<cr>
nnoremap <silent> <leader>D :call UncolorAllWords()<cr>
let g:interestingWordsGUIColors = ['#FFF6CC', '#FFD65C', '#8CCBEA', '#A4E57E', '#99FFE6', '#E6FF99', '#FFDB72', '#5CD6FF', '#99FFB3', '#FF7272', '#99FF99', '#99B3FF', '#FFB399']



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




if(has('unix'))
    nnoremap <silent> <leader>fa :execute "Locate " . expand("~")<cr>
    nnoremap <silent> <leader><leader> :execute "Locate " . Get_classpath("")<cr>
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
                \'sink' : 'e',
                \'options' : '-m',
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

    command! -nargs=1 Agcwd call fzf#run({
                \ 'source':  'ag --nogroup --column --color "'.escape(<q-args>, '"\').'"',
                \ 'sink*':    function('<sid>ag_handler'),
                \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --no-multi',
                \ 'down':    '50%'
                \ })
    
    command! -nargs=1 Ag call fzf#run({
                \ 'source':  'ag --nogroup --column --color "'.escape(<q-args>, '"\').'" ' . Get_classpath(""),
                \ 'sink*':    function('<sid>ag_handler'),
                \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-a,ctrl-x -x --multi',
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
                \ }) | else | echo 'Tagfile not found or empty!' | endif
    augroup TagSetter
        au!
        au BufEnter * call s:setTags()
    augroup END
    function! s:setTags()
        let string = Get_classpath(".git/tags") . ",~/.vimtags"
        let &tags= string
    endfunction  
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
if(has("unix"))
    let g:JavaComplete_Home = $HOME . '/vimfiles/plugged/vim-javacomplete2'
    let $CLASSPATH .= '.:' . $HOME . '/vimfiles/plugged/vim-javacomplete2/libs/javavi/target/classes'
    let g:JavaComplete_SourcePath = $HOME . '/teamf3/*.jar:' . $HOME . '/teamf3/src/**/*.java'
endif
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

nnoremap <silent> + :exec "cd " . Get_classpath("")<cr>

noremap [og :call SignifyUpdate(1)<cr>
noremap ]og :call SignifyUpdate(0)<cr>
noremap [oG :SignifyToggle<cr>
noremap ]oG :SignifyToggleHighlight<cr>
let g:signify_vcs_list = ['git']
"noremap [oG :GitGutterEnable<cr>
"noremap ]oG :GitGutterDisable<cr>
"noremap [og :GitGutterEaer<cr>
"noremap ]og :GitGutterLazy<cr>
"noremap ]og :GitGutterLazy<cr>
"
"
