noremap ]oV :IndentGuidesDisable<cr>
noremap [oV :IndentGuidesEnable<cr>

nnoremap <leader>u :GundoToggle<CR>

nnoremap [w :Obsession<CR>
nnoremap ]w :Obsession!<CR>

let g:prosession_on_startup = 0
noremap <leader>w :Prosession 
noremap <leader>W :Createsession 

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
			\ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

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

let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''

nnoremap <space>ga :Git add %:p<CR><CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q %:p<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <space>gp :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gb :Git branch<Space>
nnoremap <space>gB :Gblame<CR>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>ggP :Dispatch! git push<CR>
nnoremap <space>ggp :Dispatch! git pull<CR>
xnoremap dp :diffput<cr>
xnoremap do :diffget<cr>

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

nnoremap <leader>fb :FileBeagle<cr>
let g:filebeagle_show_hidden =  1

let delimitMate_expand_cr=1

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

noremap [oI :set autoindent<cr>
noremap ]oI :set noautoindent<cr>
noremap [oü :SetCharSwap 1<cr>
noremap ]oä :SetCharSwap 0<cr>
noremap ]oL :set foldcolumn=0<cr>
noremap [oL :set foldcolumn=4<cr>
noremap <silent> [oA :call SideLineToggle(1)<cr>
noremap <silent> ]oA :call SideLineToggle(0)<cr>

noremap [oG :GitGutterEnable<cr>
noremap ]oG :GitGutterDisable<cr>
noremap [og :GitGutterEager<cr>
noremap ]og :GitGutterLazy<cr>

