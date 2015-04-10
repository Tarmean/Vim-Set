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

let $MYVIMRC='~/vimfiles/.vimrc'
nnoremap j gj
nnoremap k gk


"tab um zwichen klammern zu springen
nnoremap <tab> %
vnoremap <tab> %
"set number
"set relativenumber

"reset search highlight with escape
nnoremap <esc> :noh<return><esc>

"if available use color scheme and fancy color things
if &t_Co > 2 || has("gui_running")
  colorscheme molokai
  syntax on
  set hlsearch
endif

"This throws new buffers into their own tabs because that is totally how vim
"uses tabs, right?...
set switchbuf=useopen,usetab

"because most keys are already taken and , is easier that \ to press
let mapleader = "\<Space>" 
"quickly edit this very file
nmap <silent> <leader>ü :e $MYVIMRC<CR> 
nmap <silent> <leader>ä :so $MYVIMRC<CR>
",v to selected just pasted text
nnoremap <leader>v V`]
",w split window vertically and switch
nnoremap <leader>s <C-w>v<C-w>l
nnoremap <leader>S <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>q :tab sp<CR>
nnoremap <leader>a :vert ball<CR>
nnoremap <leader>d :bnext 1<CR>
nnoremap <leader>e :redraw<CR>:ls<CR>
nnoremap <leader>w :only<CR>
nnoremap <leader>r <C-w>r
nnoremap <leader>n <C-w>n
nnoremap <leader>o :w<CR>
nnoremap <leader>O :edit!<CR>
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+PP
nnoremap <Leader>ö  '
nnoremap <leader>v :bd<CR>
nnoremap <leader>u :tabprevious<CR>
nnoremap <leader>i :tabnext<CR>
nnoremap <leader>, <C-o>
nnoremap <leader>. <C-l>

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
                              


nmap <leader>fm :CtrlP<cr>
nmap <leader>fb :CtrlPBuffer<cr>
nmap <leader>ff :CtrlPMixed<cr>
nmap <leader>fs :CtrlPMRU<cr>

"move windows around:
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

"switch between windows easily
nmap <silent> <Up> :wincmd k<CR>
nmap <silent> <Down> :wincmd j<CR>
nmap <silent> <Left> :wincmd h<CR>
nmap <silent> <Right> :wincmd l<CR>

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
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a"

"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"Airline
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline#extensions#eclim#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

"make supertab work with eclim auto completion
let g:SuperTabDefaultCompletionType = 'context'
"":h ins-completion

"NERDtree toggles
map <Leader>g :NERDTree %:p:h<CR>
map <F3> :NERDTreeToggle<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
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
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
