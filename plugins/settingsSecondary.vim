let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<BS>'
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
            silent! execute "imap " . l . " <C-R>=AutoPairsInsert('" . r . "')<CR>"
        endfor
    else
        for [l, r] in items(g:BracketSwapPairs) " i know what keys does but then it wouldn't be symmetric :O
            silent! execute "iunmap " . l
        endfor
    endif
endfunction
call SetCharSwap(1)
noremap [oü :SetCharSwap 1<cr>
noremap ]oä :SetCharSwap 0<cr>


nmap <M-b> <Plug>LLBreakSwitch
nnoremap <F5> :LLrefresh<CR>
nnoremap <S-F5> :LLredraw<CR>
nnoremap <F8> :LLcontinue<CR>
nnoremap <F9> :LLprint <C-R>=expand('<cword>')<CR>
vnoremap <F9> :<C-U>LLprint <C-R>=lldb#util#get_selection()<CR>


let g:syntastic_mode_map = {
            \ "mode": "active",
            \ "active_filetypes": [],
            \ "passive_filetypes": [] }

let g:fold_options = {
            \ 'show_if_and_else': 1,
            \ 'strip_template_argurments': 1,
            \ 'strip_namespaces': 1,
            \ }

fun! JumpToDef()
    if exists("*GotoDefinition_" . &filetype)
        call GotoDefinition_{&filetype}()
    else
        exe "norm! \<C-]>"
    endif
endf

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i

let g:fastfold_fold_command_suffixes = []
let g:fastfold_fold_movement_commands = []


" noremap <silent> <leader>d <Plug>InterestingWords
" noremap <silent> <leader>D <Plug>InterestingWordsClear
" nnoremap <silent> n <Plug>InterestingWordsForeward
" nnoremap <silent> N <Plug>InterestingWordsBackward
let g:interestingWordsDefaultMappings = 1
let g:interestingWordsGUIColors = ['#FFF6CC', '#FFD65C', '#8CCBEA', '#A4E57E', '#99FFE6', '#E6FF99', '#FFDB72', '#5CD6FF', '#99FFB3', '#FF7272', '#99FF99', '#99B3FF', '#FFB399']

" nnoremap <F4> call javacomplete#AddImport()<cr>
" autocmd FileType java set omnifunc=javacomplete#Complete
" let JavaComplete_LibsPath = "/home/cyril/teamf3/"





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
nnoremap <leader>u :UndotreeToggle<CR>


"let g:tagbar_left=1
"let g:tagbar_autoclose=0
"let g:tagbar_autofocus=1
"let g:tagbar_iconchars = ['▶', '▼']
"nnoremap <leader>a :Tagbar<cr>
"noremap ]oa :TagbarTogglePause<cr>
"noremap [oa :TagbarGetTypeConfig<cr>




if(has('unix'))
    " let g:fzf_layout = {'window': ''}
    function! s:fzf_statusline()
        " Override statusline as you like
        highlight fzf1 ctermfg=161 ctermbg=251
        highlight fzf2 ctermfg=23 ctermbg=251
        highlight fzf3 ctermfg=237 ctermbg=251
        setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endfunction

    function! Git_dir(command)
        " Try the directory of the current file first, then the cwd
        let cur_dir = getcwd()
        cd %:p:h
        let root = systemlist('git rev-parse --show-toplevel')[0]

        if v:shell_error
            let root = systemlist('git rev-parse --show-toplevel')[0]
            if v:shell_error
                call s:warn('Not in git repo')
                return
            endif
        endif

        execute a:command
        execute "cd " . cur_dir
    endfunction

    autocmd! User FzfStatusLine call <SID>fzf_statusline()
    " Advanced customization using autoload functions
    autocmd VimEnter * command! Colors
      \ call fzf#vim#colors({'buffer': '', 'options': '--reverse --margin 30%,0'})
    nnoremap <silent> <leader>fc :Colors<cr>

    nnoremap <silent> <leader>fa :call Git_dir("GitFiles")<cr>
    nnoremap <silent> <leader>fb :Buffers<cr>
    nnoremap <silent> <leader>fl :BLines<cr>
    nnoremap <silent> <leader>fL :Lines<cr>
    nnoremap <silent> <leader>fd :Tags<cr>
    nnoremap <silent> <leader>fD :BTags<cr>
    nnoremap <silent> <leader>fm :Marks<cr>
    nnoremap <silent> <leader>fw :Windows<cr>
    nnoremap <silent> <leader>fj :Locate ~<cr>
    nnoremap <silent> <leader>fö :Locate ~/vimfiles/plugged/<cr>
    nnoremap <silent> <leader>fs :History<cr>
    nnoremap <silent> <leader>fk :Snippets<cr>
    nnoremap <silent> <leader>fg :call Git_dir("Commits")<cr>
    nnoremap <silent> <leader>fG :call Git_dir("BCommits")<cr>
    nnoremap <silent> <leader>fh :Helptags<cr>

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

nnoremap <silent> <space>+ :exec "cd " . Get_classpath("")<cr>

noremap [oG :call SignifyUpdate(1)<cr>
noremap ]oG :call SignifyUpdate(0)<cr>
noremap [og :SignifyToggle<cr>
noremap ]og :SignifyToggleHighlight<cr>:noh<esc>
omap ix <plug>(signify-motion-inner-pending)
xmap ix <plug>(signify-motion-inner-visual)
omap ax <plug>(signify-motion-outer-pending)
xmap ax <plug>(signify-motion-outer-visual)

let g:signify_vcs_list = ['git']


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
nnoremap <space>go :Git checkout<Space>
nnoremap <space>ggP :Dispatch! git push<CR>
nnoremap <space>ggp :Dispatch! git pull<CR>
vnoremap dp :diffput<cr>
vnoremap do :diffget<cr>

nnoremap <leader>gV :Gitv --all<cr>
nnoremap <leader>gv :Gitv! --all<cr>
vnoremap <leader>gv :Gitv! --all<cr>



