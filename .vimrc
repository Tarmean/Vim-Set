"gotta be first

set nocompatible

"pathogen for easier plugins
" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory
 filetype off                    " force reloading *after* pathogen loaded
 execute pathogen#infect()
 call pathogen#helptags()

let delimitMate_expand_cr=1
set guifont=Sauce_Code_Powerline:h9:cANSI
"set glöjklasödf = aösdfjö
"location for this file

"why isn't this default?
set hidden
set backspace=indent,eol,start
set ignorecase "otherwhise smartcase doesn't work?
set smartcase
set hlsearch
set showmatch
set incsearch
set undofile
set showcmd
set wildmenu
set wildmode:full
set ttyfast
set ruler
set laststatus=2
set showmode
set scrolloff=3
set gdefault
set wrap
set splitbelow
set splitright
set noerrorbells
set visualbell
set noerrorbells
set guioptions=e
set fillchars+=vert:\ "█
set backupdir=~/.vim/backups//,.
set undodir=~/.vim/undodir//,.
set directory=~/.vim/swaps//,.
set foldmethod=syntax
set foldlevel=1
set foldclose=all
set tags=./tags;_vimtags
set spelllang=de
let g:prosession_on_startup = 0
source ~\pcSpecificVimrc.vim
"let g:syntastic_java_javac_classpath = 'C:\Users\Cyril\ProgramPraktikum\teamf3\src'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<s-space>"
let g:UltiSnipsJumpBackwardTrigger="<c-space>"
let g:tagbar_left=1
let g:tagbar_autoclose=0
let g:tagbar_autofocus=1
let g:tagbar_iconchars = ['▶', '▼']
set virtualedit=block
"let g:netrw_silent = 1
"EclimDisable
if has('autocmd')
endif
set tabstop=4
set shiftwidth=4
set expandtab

"unicode when available
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

let $MYVIMRC='~/vimfiles/.vimrc'
nnoremap j gj
nnoremap k gk



"tab um zwichen klammern zu springen
"nnoremap <s-tab> %
"vnoremap <tab> %
"set number
"set relativenumber

"reset search highlight with escape
nnoremap <esc> :noh<return><esc>

"if available use color scheme and fancy color things
if &t_Co > 2 || has("gui_running")
  colorscheme molokai
  au GUIEnter * simalt ~x
  syntax on
  set hlsearch
endif

"This throws new buffers into their own tabs because that is totally how vim
"uses tabs, right?...
"set switchbuf=useopen,usetab
"because most keys are already taken and , is easier that \ to press
let mapleader = "\<Space>"
"this makes a \ come up instead of <20>.
"map <space> <leader>
"quickly edit this very file
map  <leader>Ü :e $MYVIMRC<CR>
map  <leader>Ä :so $MYVIMRC<CR>
",w split window vertically and switch
nnoremap <leader>v <C-w>v
nnoremap <leader>V <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>C :bd!<CR>
"nnoremap <leader>q :tab sp<CR>
"nnoremap <leader>a :vert ball<CR>
"nnoremap <leader>d :bnext 1<CR>
"nnoremap <leader>e :redraw<CR>:ls<CR>
"nnoremap <leader>w:only<CR>
"nnoremap <leader>r <C-w>r
"nnoremap <leader>n <C-w>n
"nnoremap <leader>i :w<CR>
"nnoremap <leader>O :edit!<CR>
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+PP
nnoremap <Leader>ö :w<CR>
map ü [
map ä ]
map Ä }
map Ü {
set langmap=\\ü\\[,\\ä\\]
nnoremap <leader>a :Tagbar<cr>
"nnoremap <c-[> <c-t>
"noremap <c-ö> <c-]>
noremap <leader>ä <c-]>
noremap <leader>ü <c-t>
let g:SignatureMap = {
            \ 'Leader'             :  "m",
            \ 'PlaceNextMark'      :  "m,",
            \ 'ToggleMarkAtLine'   :  "m.",
            \ 'PurgeMarksAtLine'   :  "m-",
            \ 'DeleteMark'         :  "dm",
            \ 'PurgeMarks'         :  "m<Space>",
            \ 'PurgeMarkers'       :  "m<BS>",
            \ 'GotoNextLineAlpha'  :  "']",
            \ 'GotoPrevLineAlpha'  :  "'[",
            \ 'GotoNextSpotAlpha'  :  "`]",
            \ 'GotoPrevSpotAlpha'  :  "`[",
            \ 'GotoNextLineByPos'  :  "]'",
            \ 'GotoPrevLineByPos'  :  "['",
            \ 'GotoNextSpotByPos'  :  "]s",
            \ 'GotoPrevSpotByPos'  :  "[s",
            \ 'GotoNextMarker'     :  "[+",
            \ 'GotoPrevMarker'     :  "[-",
            \ 'GotoNextMarkerAny'  :  "]=",
            \ 'GotoPrevMarkerAny'  :  "[=",
            \ 'ListLocalMarks'     :  "m/",
            \ 'ListLocalMarkers'   :  "m?"
            \ }
noremap [oü :SetCharSwap 1<cr>
noremap ]oä :SetCharSwap 0<cr>
noremap [oI :set autoindent<cr>
noremap ]oI :set noautoindent<cr>
noremap [oG :GitGutterEnable<cr>
noremap ]oG :GitGutterDisable<cr>
noremap [og :GitGutterEager<cr>
noremap ]og :GitGutterLazy<cr>
noremap ]os :SyntasticToggleMode<cr>
noremap [os :SyntasticCheck<cr>
noremap ]oa :TagbarTogglePause<cr>
noremap [oa :TagbarGetTypeConfig<cr>
noremap ]oc :call SetJavaComplete(0)<cr>
noremap [oc :call SetJavaComplete(1)<cr>
noremap <silent> [oA :call SideLineToggle(1)<cr>
noremap <silent> ]oA :call SideLineToggle(0)<cr>
"onoremap 
"nnoremap üü [[
"nnoremap üä []
"nnoremap äü ][
"nnoremap ää ]]
nnoremap [w :Obsession<CR>
nnoremap ]w :Obsession!<CR>
noremap <leader>w :Prosession 
noremap <leader>W :Createsession 
"nnoremap ü) [)
"nnoremap ü( [(
"nnoremap ä( ](
"nnoremap ä) ])
"nnoremap ü{ [{
"nnoremap ü} [}
"nnoremap a{ ]{
"nnoremap ä} ]}
"nnoremap üm [m
"nnoremap üM [M
"nnoremap äm ]m
"nnoremap äM ]M
"nnoremap üs [s
"nnoremap äs ]s
"nnoremap ,, ,
"nnoremap <leader>v :bd<CR>
nnoremap <leader>I :<C-U>call Clone_rel_tab_backwards(1, v:count)<CR>
nnoremap <leader><c-I> :<C-U>call Clone_rel_tab_backwards(0, v:count)<CR>
nnoremap <leader>O :<C-U>call Clone_rel_tab_forwards(1, v:count)<CR>
nnoremap <leader><c-O> :<C-U>call Clone_rel_tab_forwards(0, v:count)<CR>
nnoremap <leader>i gT
nnoremap <silent><leader>o :<C-U>call RelativeNext(v:count1)<CR>
nnoremap <leader>Z <c-i>
nnoremap <leader>z <c-o>
nnoremap <leader>u :GundoToggle<CR>
"nnoremap <leader>e :<C-U>call Copy_or_move_selected_buffer_into_tab(1, v:count)<CR>
"nnoremap <leader>E :<C-U>call Copy_or_move_selected_buffer_into_tab(0, v:count)<CR>
vnoremap <leader>r :<c-u>execute ":'<,'>Tabular /"nr2char(getchar())<cr>
vnoremap <leader>R :Tabular<space>/
nnoremap <cr> :
vnoremap <cr> :
"nnoremap <s-cr> O<esc>
"nnoremap <leader><c-u> :<C-U>call Clone_rel_tab_backwards(0, v:count)
"nnoremap <leader><c-U> :<C-U>call Clone_rel_tab_backwards(1, v:count)<CR>
"nnoremap <leader><c-i> :<C-U>call Clone_rel_tab_forwards(0, v:count)<CR>
"nnoremap <leader><c-I> :<C-U>call Clone_rel_tab_forwards(1, v:count)
nnoremap / /\v
cnoremap %s/ %s/\v
nnoremap Y y$

"nnoremap <leader>, <C-o>
"nnoremap <leader>. <C-l>


"numbers to swtich between buffers quickly
nnoremap <leader>1 :buffer 1 <CR>
nnoremap <leader>2 :buffer 2 <CR>
nnoremap <leader>3 :buffer 3 <CR>
nnoremap <leader>4 :buffer 4 <CR>
nnoremap <leader>5 :buffer 5 <CR>
nnoremap <leader>6 :buffer 6 <CR>
nnoremap <leader>7 :buffer 7 <CR>
nnoremap <leader>8 :buffer 8 <CR>
nnoremap <leader>9 :buffer 9 <CR>
nnoremap <leader>0 :buffer 0 <CR>


" Unite
"let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
let g:unite_source_rec_async_command =
            \ 'ag --follow --nocolor --nogroup --hidden -g ""'
nnoremap <leader>fJ :Unite -buffer-name=files   -start-insert file_rec:!<cr>
"C-u>Unite -buffer-name=files   -start-insert file_rec:!<cr>
nnoremap <leader>fj :<C-u>Unite -buffer-name=files   -start-insert file<cr>
nnoremap <leader>fs :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>fk :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>fy :<C-u>Unite -buffer-name=yank    history/yank<cr>
nnoremap <leader>ff :<C-u>Unite -buffer-name=buffer  buffer<cr>
nnoremap <leader>fl :<C-u>Unite -buffer-name=buffer -start-insert -no-split line<cr>

nnoremap <leader>fb :FileBeagle<cr>

"Fugitive Git stuff
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
" same bindings for merging diffs as in normal mode
xnoremap dp :diffput<cr>
xnoremap do :diffget<cr>

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  nmap <buffer> <esc>   <Plug>(unite_exit)
  map <buffer> <leader><c>   <Plug>(unite_exit)
endfunction

let g:filebeagle_show_hidden =  1

"nmap <leader>fj :CtrlP<cr>
"nmap <leader>fk :CtrlPBuffer<cr>
"nmap <leader>ff :CtrlPMixed<cr>
"nmap <leader>fs :CtrlPMRU<cr>


noremap <silent><leader>h  : call WinMove('h')<cr>
noremap <silent><leader>k  : call WinMove('k')<cr>
noremap <silent><leader>l  : call WinMove('l')<cr>
noremap <silent><leader>j  : call WinMove('j')<cr>
"noremap <silent><c-H>      : (3wincmd) <<cr>
"noremap <silent><c-L>      : (3wincmd) ><cr>
"noremap <silent><c-J>      : (3wincmd) +<cr>
"noremap <silent><c-K>      : 3wincmd -<cr>

"switch between windows easily
nmap <left>  :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up>    :3wincmd +<cr>
nmap <down>  :3wincmd -<cr>

"session stuff
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds


"F2 for paste mode so pasted stuff isn't indented
set pastetoggle=<F2>

"complete current word with first matching one, repeat to toggle between
"options. Ctrl-P to search backwards, Ctrl-N to look forwards
map! ^P ^[a. ^[hbmmi?\<^[2h"zdt.@z^Mywmx`mP xi
map! ^N ^[a. ^[hbmmi/\<^[2h"zdt.@z^Mywmx`mP xi

"F11 show current buffer in the explorer
nmap <F11> :!start explorer /e,/select,%:p<CR>
imap <F11> <Esc><F11>

"F8 for next buffer, shift-F8 for previous one
nnoremap <F8> :sbnext<CR>
nnoremap <S-F8> :sbprevious<CR>

"save in two keypresses
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"Airline
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''
"let g:airline#extensions#eclim#enabled = 1
"let g:airline#extensions#syntastic#enabled = 1

"make supertab work with eclim auto completion
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
			\ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
"":h ins-completion
let g:tinykeymap#mapleader = "<leader>"
" "NERDtree toggles
" map <Leader>g :NERDTree %:p:h<CR>
" map <F3> :NERDTreeToggle<CR>

let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"hi CtrlSpaceSelected term=reverse ctermfg=187  ctermbg=23  cterm=bold
"hi CtrlSpaceNormal   term=NONE    ctermfg=244  ctermbg=232 cterm=NONE
"hi CtrlSpaceSearch   ctermfg=220  ctermbg=NONE cterm=bold
"hi CtrlSpaceStatus   ctermfg=230  ctermbg=234  cterm=NONE
let g:airline_exclude_preview=1


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


if has("autocmd")

  " Enable file type detection.file file file
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

      "autocmd FileType text setlocal textwidth=78
      "actually don't because that is completly obnoxious when editing tables
      " When    editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      autocmd BufReadPost
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  augroup END

  if !exists('numBlacklist')
      let numBlacklist = []
  endif

  let numBlacklist += ['help', 'filebeagle']


  autocmd GUIEnter * set visualbell t_vb=
  autocmd FileType FileBeagle map <buffer> <leader><c> q
else

    set autoindent" always set autoindenting on

endif " has("autocmd")



" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif


