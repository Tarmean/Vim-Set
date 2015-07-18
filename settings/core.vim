set guifont=Sauce_Code_Powerline:h9:cANSI

set lazyredraw
set hidden
set backspace=indent,eol,start
set ignorecase
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
set tags=""
set spelllang=de
source ~\pcSpecificVimrc.vim
set virtualedit=block
set tabstop=4
set shiftwidth=4
set expandtab

highlight diffAdded guifg=#00bf00
highlight diffRemoved guifg=#bf0000
highlight diffAdded ctermfg=34
highlight diffRemoved ctermfg=124

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

if &t_Co > 2 || has("gui_running")
  if(!exists("g:seoul256_background"))
    let g:seoul256_background = 234
  endif
  colorscheme gruvbox
  set background=dark
  "colorscheme seoul256
  au GUIEnter * simalt ~x
  syntax on "admittedly has a significant performance penalty but come on...
  set hlsearch
endif

let $MYVIMRC='~/vimfiles/.vimrc'

nnoremap j gj
nnoremap k gk
nnoremap <esc> :noh<return><esc>
map  <leader>Ü :e $MYVIMRC<CR>
map  <leader>Ä :so $MYVIMRC<CR>
nnoremap <leader>v <C-w>v
nnoremap <leader>V <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>C :bd!<CR>
map ü [
map ä ]
map Ä '
map Ü `
nnoremap <cr> :
vnoremap <cr> :
nnoremap / /\v
set autoindent

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif
