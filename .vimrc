
set nocompatible

let mapleader = "\<Space>"

source ~/vimfiles/plugins/plugins.vim
source ~/vimfiles/plugins/settings.vim

set guifont=Sauce_Code_Powerline:h9:cANSI

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
source ~\pcSpecificVimrc.vim
set virtualedit=block
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

"if available use color scheme and fancy color things
if &t_Co > 2 || has("gui_running")
  colorscheme molokai
  au GUIEnter * simalt ~x
  syntax on
  set hlsearch
endif
nnoremap j gj
nnoremap k gk

nnoremap <esc> :noh<return><esc>

map  <leader>Ü :e $MYVIMRC<CR>
map  <leader>Ä :so $MYVIMRC<CR>
nnoremap <leader>v <C-w>v
nnoremap <leader>V <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>C :bd!<CR>
nnoremap <leader>q :tab sp<CR>
nnoremap <leader>e :redraw<CR>:ls<CR>

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
nnoremap <cr> :
vnoremap <cr> :
nnoremap / /\v
cnoremap %s/ %s/\v
nnoremap Y y$

noremap <leader>ä <c-]>
noremap <leader>ü <c-t>

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

"switch between windows easily
nmap <left>  :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up>    :3wincmd +<cr>
nmap <down>  :3wincmd -<cr>

"session stuff, probably managed by obsession
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

"save in two keypresses
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a



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
  autocmd BufNewFile,BufRead *.nasm set ft=nasm
  autocmd BufNewFile,BufRead *.asm set ft=nasm
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



