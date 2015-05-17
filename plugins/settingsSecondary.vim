
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

"let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
let g:unite_source_rec_async_command =
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


noremap [oG :GitGutterEnable<cr>
noremap ]oG :GitGutterDisable<cr>
noremap [og :GitGutterEager<cr>
noremap ]og :GitGutterLazy<cr>
