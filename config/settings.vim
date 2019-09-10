" set guifont=Sauce_Code_Powerline:h13:cANSI

if !has("unix")
		" set shell=powershell shellquote=( shellpipe=\| shellredir=> shellxquote=
		" set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
endif
colorscheme gruvbox

" don't give |ins-completion-menu| messages.
set background=light
set cmdheight=2
set shortmess+=c
set inccommand=nosplit
set termguicolors
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
set foldmethod=syntax "taken care of by fast fold most of the time
set noerrorbells visualbell t_vb=
set foldlevel=1
set foldclose=""
" set tags=""
set spelllang=de,en
set virtualedit=block
set tabstop=4
set shiftwidth=4
set expandtab
set ssop-=options "do not store global and local values in a session
set ssop-=folds   "do not store folds
set list
set lcs=eol:⏎,tab:␉·,trail:␠,nbsp:⎵

highlight diffAdded guifg=#00bf00
highlight diffRemoved guifg=#bf0000
highlight diffAdded ctermfg=34
highlight diffRemoved ctermfg=124

if has("multi_byte") && !exists("g:encodingset")
  let g:encodingset = 1
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
  au GUIEnter * simalt ~x
  syntax on 
  set hlsearch
  noh "otherwhise the highlighting from the last search is reactivated after each vimrc reload
endif

let $MYVIMRC='~/vimfiles/.vimrc'


nnoremap <silent><leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>
nnoremap <silent><leader>? :execute "Ag '" .  substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<cr>


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

      autocmd GUIEnter * set visualbell t_vb=
  augroup END

  if !exists('numBlacklist')
      let numBlacklist = []
  endif
  let numBlacklist += ['help', 'filebeagle']


  nnoremap Q q:
  augroup commandWin
      au!
      autocmd CmdwinEnter * map <buffer> <CR> <CR>q:
      autocmd CmdwinEnter * map <buffer> <esc> :quit<CR>
  augroup END
endif 

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction
