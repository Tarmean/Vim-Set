set guifont=Sauce_Code_Powerline:h9:cANSI

set autoindent
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
set guioptions=e
set fillchars+=vert:\ "█
set backupdir=~/.vim/backups//,.
set undodir=~/.vim/undodir//,.
set directory=~/.vim/swaps//,.
set foldmethod=syntax "overwritten by fastfold in almost all cases
set noerrorbells visualbell t_vb=
set foldlevel=1
set foldclose=""
set tags=""
set spelllang=de,en
set virtualedit=block
set tabstop=4
set shiftwidth=4
set expandtab
source ~\pcSpecificVimrc.vim

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

if &t_Co > 2 || has("gui_running") || has("unix")
  if(!exists("g:seoul256_background"))
    let g:seoul256_background = 234
  endif
  colorscheme gruvbox
  set background=dark
  au GUIEnter * simalt ~x
  syntax on 
  set hlsearch
  noh "otherwhise the highlighting from the last search is reactivated after each vimrc reload
endif

let $MYVIMRC='~/vimfiles/.vimrc'

function! RightOrElse()
    let c = col(".")
    echo c
    norm $
    if c == col(".")
        silent! norm zo
    endif
endfunc
command! RightOr call RightOrElse()

function! LeftOrElse()
    let c = col(".")
    norm ^
    if c == col(".")
        silent! norm zc
    endif
endfunc
command! LeftOr call LeftOrElse()

"noremap J L
"noremap K H
"noremap <c-j> J
"nnoremap + <c-^>
nnoremap j gj
nnoremap k gk
nnoremap <silent> <esc> :noh<return><esc>
nnoremap <Leader>ö :w<CR>
map  <leader>Ü :e $MYVIMRC<CR>
map  <leader>Ä :so $MYVIMRC<CR>
nnoremap <leader>v <C-w>v
nnoremap <leader>V <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>C :bd!<CR> 
map ü [
map ä ]
map Ä }
map Ü {
nnoremap <cr> :
vnoremap <cr> :
nnoremap / /\v

noremap H ^
noremap L $
nnoremap gI `.

nnoremap =<space>p ]p=']
nnoremap =<space>P [p=']
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

cnoremap %s/ %s/\v
cnoremap  w!! w !sudo tee % > /dev/null
nnoremap Y y$

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}
nnoremap <silent><leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>
nnoremap <silent><leader>? :execute "Ag '" .  substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<cr>

nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz


if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif



if has("autocmd")
  filetype plugin indent on

  augroup vimrcEx
  au!

      " When    editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe 'normal g`"zvzz' |
        \ endif

  augroup END

  if !exists('numBlacklist')
      let numBlacklist = []
  endif
  let numBlacklist += ['help', 'filebeagle']

  autocmd FileType FileBeagle map <buffer> <leader><c> q
  autocmd BufNewFile,BufRead *.nasm set ft=nasm
  autocmd BufNewFile,BufRead *.asm set ft=nasm
  autocmd GUIEnter * set visualbell t_vb=

  augroup commandWin
      au!
      autocmd CmdwinEnter * map <buffer> <CR> <CR>q:
      autocmd CmdwinEnter * map <buffer> <esc> :quit<CR>
  augroup END

  autocmd BufEnter *.hs set formatprg=pointfree\ --stdin
else

    set autoindent" always set autoindenting on

endif 
