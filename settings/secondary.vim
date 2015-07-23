nnoremap <leader>q :tab sp<CR>
nnoremap <leader>e :redraw<CR>:ls<CR>


noremap <leader>ä <c-]>
noremap <leader>ü <c-t>


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

"F11 show current buffer in the explorer
nmap <F11> :!start explorer /e,/select,%:p<CR>
imap <F11> <Esc><F11>



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
