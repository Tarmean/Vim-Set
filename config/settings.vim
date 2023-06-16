" set guifont=Sauce_Code_Powerline:h13:cANSI

" if !has("unix")
" 		let &shell = has('win32') ? 'powershell' : 'pwsh'
" 		let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command '
" 		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
" 		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
" 		set shellquote= shellxquote=
" endif
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_contrast_light='hard'
set bg=light
colorscheme gruvbox

if has('nvim')
    set inccommand=nosplit
endif

" The haskell syntax highlighting has cError highlighting for c preprocessor
" directives. Hashes at the start of the line error, this breaks with overloadedlabels like
"     #nodes . at k .= Nothing
let hs_allow_hash_operator=1

" don't give |ins-completion-menu| messages.
set mouse +=a
set cmdheight=2
set shortmess+=c
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
set backup
set writebackup
set backupdir=~/.vim/backups//,.
set directory=~/.vim/swaps//,.
if has('nvim')
    set undodir=~/.vim/undodir//,.
else
    set undodir=~/.vim/undodirvim//,.
endif
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
set lcs=tab:␉·,trail:␠,nbsp:⎵


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


if IsReal()
  nnoremap <leader>b :ClearHiddenBufs<cr>
endif


if !exists(":DiffUnsaved")
    command DiffUnsaved vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

if has("autocmd")
  filetype plugin indent on

  augroup vimrcEx
  au!
      " autocmd filetype haskell set shiftwidth=2 tabstop=2

      " When    editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      if (!exists("g:vscode"))
          autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe 'normal g`"zvzz' |
            \ endif
      endif

      autocmd GUIEnter * set visualbell t_vb=
      autocmd FileType haskell let b:coc_root_patterns = ['.git', '.cabal', 'stack.yaml']
      au BufNewFile,BufRead *.agda setf agda
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


function! s:delete_hidden_buffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
command! ClearHiddenBufs call s:delete_hidden_buffers()
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


function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! RetabTrailing call <SID>StripTrailingWhitespaces()
