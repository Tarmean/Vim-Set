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
set noerrorbells visualbell t_vb=
set guioptions=e
set fillchars+=vert:\ "█
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
set virtualedit=block

let $MYVIMRC='~/vimfiles/.vimrc'
nnoremap j gj
nnoremap k gk

function! RelativeNext(count)

    let total_tabs = tabpagenr("$")

    let cur_tab = tabpagenr()

    let next_tab = (cur_tab + a:count -1) % total_tabs + 1

    exec "tabnext" .  next_tab

endfunction
command! -count=1 TabNext call RelativeNext(<count>)
command! -count JumpBackward norm! <count><C-O>
command! -count JumpForward norm! <count><C-i>


"totes stole this from ctrlspace. Sorry, but not keeping the entire thing for one feature :P
function! Copy_or_move_selected_buffer_into_tab(move, tab)
"this should work vor the current buffer
  let l:cur_buffer = bufnr('%')
  let l:total_tabs = tabpagenr('$')
  "if the new tab has the current buffer in a different view that one would be
  "used once the buffer gets reopened. there is probably some way it's
  "supposed to be done but yay workarounds
  let l:winview = winsaveview()
 "" let l:lines =
"not sure if these are all necessary but better save than sorry I guess
      if !getbufvar(str2nr(l:cur_buffer), '&modifiable') || !getbufvar(str2nr(l:cur_buffer), '&buflisted') || empty(bufname(str2nr(l:cur_buffer))) || (a:tab == tabpagenr() && a:move == 1)
    return
  endif
  let l:selected_buffer_window = bufwinnr(l:cur_buffer)
  if a:move > 0
        if selected_buffer_window != -1
      if bufexists(l:cur_buffer) && (!empty(getbufvar(l:cur_buffer, "&buftype")) || filereadable(bufname(l:cur_buffer)))
        silent! exe l:selected_buffer_window . "wincmd c"
      else
        return
      endif
    endif
  endif
  if a:tab  > l:total_tabs
    "let l:total_tabs = (l:total_tabs + 1)
    silent! exe l:total_tabs . "tab  sb" . l:cur_buffer
  else
    if (a:move == 2 || a:move == -1) && a:tab == 0
      silent! exe "normal! gT"
    else
      silent! exe "normal! " . a:tab . "gt"
    endif
    silent! exe ":vert sbuffer " . l:cur_buffer
  endif
  call winrestview(l:winview)
endfunction
function! Clone_rel_tab_forwards(move, ...)
  let l:distance = (a:0>0 && a:1>0) ? a:1 : 1
  let l:cur_tab = tabpagenr()
  let l:goal_tab = (l:cur_tab + l:distance)
  call Copy_or_move_selected_buffer_into_tab(a:move, l:goal_tab)
endfunction

function! Clone_rel_tab_backwards(move, ...)
  let l:distance = (a:0>0 && a:1>0) ? a:1 : 1
  let l:cur_tab = tabpagenr()
  let l:goal_tab = (l:cur_tab - l:distance)
  call Copy_or_move_selected_buffer_into_tab(a:move, l:goal_tab)
endfunction

command!  -narg=* CloneToTab exec Copy_or_move_selected_buffer_into_tab(<args>)

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
noremap <silent> <leader>ü :e $MYVIMRC<CR>
noremap <silent> <leader>ä :so $MYVIMRC<CR>
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
"nnoremap ,, ,
"nnoremap <leader>v :bd<CR>
nnoremap <leader>U :<C-U>call Clone_rel_tab_backwards(1, v:count)<CR>
nnoremap <leader><c-u> :<C-U>call Clone_rel_tab_backwards(0, v:count)<CR>
nnoremap <leader>I :<C-U>call Clone_rel_tab_forwards(1, v:count)<CR>
nnoremap <leader><c-I> :<C-U>call Clone_rel_tab_forwards(0, v:count)<CR>
nnoremap <leader>u gT
nnoremap <silent><leader>i :<C-U>call RelativeNext(v:count1)<CR>
nnoremap <leader>Z <c-i>
nnoremap <leader>z <c-o>
nnoremap <leader>e :<C-U>call Copy_or_move_selected_buffer_into_tab(1, v:count)<CR>
nnoremap <leader>E :<C-U>call Copy_or_move_selected_buffer_into_tab(0, v:count)<CR>
vnoremap <leader>r :<c-u>execute ":'<,'>Tabular /"nr2char(getchar())<cr>
vnoremap <leader>R :Tabular<space>/
nnoremap <cr> o<esc>
nnoremap <s-cr> O<esc>
"nnoremap <leader><c-u> :<C-U>call Clone_rel_tab_backwards(0, v:count)
"nnoremap <leader><c-U> :<C-U>call Clone_rel_tab_backwards(1, v:count)<CR>
"nnoremap <leader><c-i> :<C-U>call Clone_rel_tab_forwards(0, v:count)<CR>
"nnoremap <leader><c-I> :<C-U>call Clone_rel_tab_forwards(1, v:count)
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
let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>fJ :<C-u>Unite -buffer-name=files   -start-insert file_rec:!<cr>
nnoremap <leader>fj :<C-u>Unite -buffer-name=files   -start-insert file<cr>
nnoremap <leader>fs :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>fk :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>fy :<C-u>Unite -buffer-name=yank    history/yank<cr>
nnoremap <leader>ff :<C-u>Unite -buffer-name=buffer  buffer<cr>
nnoremap <leader>fl :<C-u>Unite -buffer-name=buffer -start-insert -no-split line<cr>

" Custom mappings for the unite buffer
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



"nmap <leader>fj :CtrlP<cr>
"nmap <leader>fk :CtrlPBuffer<cr>
"nmap <leader>ff :CtrlPMixed<cr>
"nmap <leader>fs :CtrlPMRU<cr>

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

map <leader>h              :call WinMove('h')<cr>
map <leader>k              :call WinMove('k')<cr>
map <leader>l              :call WinMove('l')<cr>
map <leader>j              :call WinMove('j')<cr>

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
"let g:airline#extensions#eclim#enabled = 1
"let g:airline#extensions#syntastic#enabled = 1

"make supertab work with eclim auto completion
let g:SuperTabDefaultCompletionType = 'context'
"":h ins-completion
let g:tinykeymap#mapleader = "<leader>"
" "NERDtree toggles
" map <Leader>g :NERDTree %:p:h<CR>
" map <F3> :NERDTreeToggle<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"hi CtrlSpaceSelected term=reverse ctermfg=187  ctermbg=23  cterm=bold
"hi CtrlSpaceNormal   term=NONE    ctermfg=244  ctermbg=232 cterm=NONE
"hi CtrlSpaceSearch   ctermfg=220  ctermbg=NONE cterm=bold
"hi CtrlSpaceStatus   ctermfg=230  ctermbg=234  cterm=NONE
let g:airline_exclude_preview=1

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



if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

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
