if exists(':Delete')
    delcommand Delete
endif
let g:textobj_comment_no_default_key_mappings = 1
omap Ac <Plug>(textobj-comment-big-a)
omap ac <Plug>(textobj-comment-a)
omap ic <Plug>(textobj-comment-i)
nmap vAc v<Plug>(textobj-comment-big-a)
nmap vac v<Plug>(textobj-comment-a)
nmap vic v<Plug>(textobj-comment-i)
nmap _  <Plug>ReplaceWithRegisterOperator
nmap __ <Plug>ReplaceWithRegisterOperatorik
nmap <space>_ "+_
if exists("g:vscode")
    finish
endif
augroup DirvishMappings
  autocmd!
  autocmd filetype dirvish nmap <buffer> q <plug>(dirvish_quit)
  " autocmd bufreadpost fugitive://* set bufhidden=wipe
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd BufReadPost quickfix nnoremap <buffer> J :cnext<cr>
  autocmd BufReadPost quickfix nnoremap <buffer> K :cprev<cr>
augroup end
let g:snips_author= 'cyril'
let g:snips_email='cyrilfahlenbock@outlook.com'
let g:snips_github='https:github.com/Tarmean'
nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround
nnoremap <space>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1
func! Seek(line, col, syn, dir)
    let line = a:line
    let col = a:col
    while synID(line, col+a:dir, 1) == a:syn
      let col += a:dir
      if (col == 0) || (col ==  col('$'))
          let line += a:dir
      endif
    endwhile
    return [0, line, col, 0]
endfunc
func! SelectHighlight()
   let cl = line(".")
   let cc = col(".")
   let cs = synID(cl, cc, 1)
   if cs == 0
       return
   endif
   let start = Seek(cl, cc, cs, -1)
   let end = Seek(cl, cc, cs, 1)
   return ['v', start, end]
endfunc

call textobj#user#plugin('highlight', {
\   '-': {
\     'select-a-function': 'SelectHighlight',
\     'select-a': 'ah',
\     'select-i-function': 'SelectHighlight',
\     'select-i': 'ih',
\   },
\ })

noremap <silent> - :call Dirvish_wrap_up(expand('%'))<cr>
if !exists("g:Dirvish_Added")
    let g:Dirvish_Added = 1
    au FileType dirvish call s:dirvish_init()
endif
func! s:dirvish_init()
    noremap <buffer><silent> - :call Dirvish_wrap_up('%:h:h')<cr>
    noremap <buffer><silent> h :call Dirvish_wrap_up('%:h:h')<cr>
    nnoremap <buffer><silent>  l :<c-u>.call dirvish#open("edit", 0)<cr>
    xnoremap <buffer><silent>  l :call dirvish#open("edit", 0)<cr>
    noremap <buffer> <cr> :
    nnoremap <buffer> + :e %/
    nmap <expr><buffer> <esc> v:hlsearch?":noh\<cr>":"\<Plug>(dirvish_quit)"
    " skip both dirvish's and my mappings because \v isn't needed for file paths
    nnoremap <buffer> / /
    nnoremap <buffer> ? ?
    cnoremap <expr><buffer> <cr> Dirvish_append_search()
    set ma
    sort r /[^\/]$/
endfunc
func! Dirvish_wrap_up(path) " au */tomatically seek the directory or file when going up
    let loc = escape(substitute(expand("%:p"), '/', '\', 'g'), '\')
    silent! execute "Dirvish " . a:path
    " execute "lcd ".a:path
    call search( loc . '$')
endfunc
func! Dirvish_append_search()
    let isSearch = !(getcmdtype() == "/" || getcmdtype() == "?")
    let isEscaped = getcmdline() =~# '\ze[^\/]*[\/]\=\$$'
    if isSearch || isEscaped
        return "\<cr>"
    else
        return '\ze[^\/]*[\/]\=$'
    endif
endfunc
let g:tf_workaround= 0
noremap ]oz :Goyo!<cr>
noremap [oz :Goyo<cr>:IndentLinesDisable<cr>
" let gutentags_ctags_tagfile=".git/tags"
let g:gutentags_cache_dir="~/.vim/tags/"
" let g:sneak#streak=1
" let g:sneak#streak_esc = "\<esc>"
" let g:sneak#s_next=1
" let g:sneak#textobj_z=0
" let g:sneak#use_ic_scs = 1
" nmap f <Plug>Sneak_f
" lmap F <Plug>Sneak_F
" xmap f <Plug>Sneak_f
" xmap F <Plug>Sneak_F
" omap f <Plug>Sneak_f
" omap F <Plug>Sneak_F
nnoremap [w :Obsession<CR>
nnoremap ]w :Obsession!<CR>
let g:prosession_on_startup = 0
noremap <leader>b :Prosession
noremap <leader>B :Createsession
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
            \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus'], ['readonly', 'gitversion', 'filename'] ],
      \   'right': [ [ 'lineinfo', 'percent', 'modified' ],
      \              [ 'filetype' ]]
      \ },
      \ 'inactive': {
            \ 'left': [ ['gitversion', 'filename']],
            \ 'right': [ [ 'lineinfo', 'percent' ], [], [], [] ] },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \ },
      \ 'component': {
      \   'gitversion': '%{LightLineGitversion()}',
      \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'},
      \ 'component_expand': {
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'lineinfo': '(winwidth(0) >= 70)',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
function! FugitiveBufferIdent(...)
  let path = a:0 > 0 ? a:1 : expand("%")
  let p = tr(path, '\', '/')
  return matchlist(p, '\c^fugitive:\%(//\)\=\(.\{-\}\)\%(//\|::\)\(\x\{40,\}\|[0-3]\)\(/.*\)\=$')
endfunc
function! LightLineGitversion()
  let l:ls = FugitiveBufferIdent()
  if len(l:ls) == 0
      if &diff
          let out = 'working copy'
      else
          let out = FugitiveHead(7)
      endif
  else
      let l:idx = l:ls[2]
      if l:idx == '0'
          let out = 'index'
      elseif l:idx == '2'
          let out = 'target'
      elseif l:idx == '3'
          let out = 'merge'
      else
          let out = l:idx[0:6]
      endif
  endif
  if (len(out) != 0)
      let out = '[' . out . ']'
  endif
  return out
endfunction
augroup PluginAutocomands
    autocmd!
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
    " autocmd BufReadPost * DetectIndent
    autocmd User FzfStatusLine call <SID>fzf_statusline()
    autocmd ColorScheme * call s:lightline_update()
augroup END
function! s:lightline_update()
    if !exists('g:loaded_lightline')
        return
    endif
    try
        call LoadLightlineGruvbox()
        if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow\|gruvbox'
          let g:lightline.colorscheme =
            \substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
          call lightline#init()
          call lightline#colorscheme()
          call lightline#update()
    endif
  catch
  endtry
endfunction
let unified_diff#executable = 'git'
let unified_diff#arguments = [
            \   'diff', '--no-index', '--no-color', '--no-ext-diff', '--unified=0',
            \ ]
let unified_diff#iwhite_arguments = [
            \   '--ignore--all-space',
            \ ]
let g:splice_prefix = "+"
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
fun! JumpToDef()
    if exists("*GotoDefinition_" . &filetype)
        call GotoDefinition_{&filetype}()
    else
        exe "norm! \<C-]>"
    endif
endf
" Jump to tag
let g:fastfold_fold_command_suffixes = []
let g:fastfold_fold_movement_commands = []
if(has('nvim'))
    command! -nargs=* Z :call Z(<f-args>)
    function! Z(...)
        let cmd = 'fasd -d -e printf'
        for arg in a:000
            let cmd = cmd . ' ' . arg
        endfor
        let path = system(cmd)
        if isdirectory(path)
            echo path
            exec 'cd ' . path
        endif
    endfunction
    function! s:fzf_statusline()
        " Override statusline as you like
        highlight fzf1 ctermfg=161 ctermbg=251
        highlight fzf2 ctermfg=23 ctermbg=251
        highlight fzf3 ctermfg=237 ctermbg=251
        setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endfunction
    let g:fzf_layout = { 'window': 'enew' }
    " Advanced customization using autoload functions
    func! Fzf_remap()
          command! BTags call fzf#vim#btags(<q-args>, { 'window': 'enew' })
    endfunc
    function! Tag_or_reload(command)
        if (&tags == '')
            call gutentags#rescan()
        endif
        execute a:command
    endfunc
    nnoremap <silent> <leader><leader> :call Git_dir('GitFiles')<cr>
    nnoremap <silent> <leader>fm :Marks<cr>
    nnoremap <silent> <leader>ff :Buffers<cr>
    nnoremap <silent> <leader>fl :BLines<cr>
    nnoremap <silent> <leader>fw :Windows<cr>
    nnoremap <silent> <leader>fs :History<cr>
    nnoremap <silent> <leader>fc :call Git_dir("Commits")<cr>
    nnoremap <silent> <leader>fb :call Git_dir("Commits")<cr>
endif
au VimEnter * let g:fzf_commits_log_options = '--all --color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')
cabbrev git Git
nnoremap <space>ga :execute 'Git add ' . expand('%:p')<CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <silent> <leader>gb :Gblame -wccc<cr>
vnoremap <space>gl :Gistory<cr>
nnoremap <space>gl :Gistory<cr>
command! -nargs=* -range=% Gistory call SetupGistory(<line1>, <line2>, <f-args>)
function! SetupGistory(l1, l2, ...)
    tab split
    let t:diff_tab = tabpagenr()
    if (a:l1 != 1) || (a:l2 != line("$"))
        exec a:l1 . "," . a:l2 . "Glog -w " . join(a:000, " ")
    else
        exec "0Glog -w " . join(a:000, " ")
    endif
    call SetupDiff()
    let g:last_known = getqflist({'id':0, 'changedtick': 0, 'idx': 0})
    augroup Gistory
        au!
        autocmd TabLeave * tabc | augroup Gistory | au! | augroup END
        autocmd BufEnter  * call QueueUpDiff()
        autocmd CursorMoved  * call QueueUpDiff()
    augroup END
endfunc
" nnoremap ]q :cnext<cr>:call SetupDiff()<cr>
" nnoremap [q :cprev<cr>:call SetupDiff()<cr>
function! QueueUpDiff()
    if exists('g:last_known') && g:last_known == getqflist({'id':0, 'changedtick': 0, 'idx': 0})
        return
    endif
    let g:last_known = getqflist({'id':0, 'changedtick': 0, 'idx': 0})
    call feedkeys(":call SetupDiff()\<cr>", 'n')
endfunc
function! SetupDiff()
    if !exists("t:diff_tab")
        echo "2"
        return
    endif
    if t:diff_tab != tabpagenr()
        echo "setup_diff wrong tabpagenr"
        return
    endif
    let qf = getqflist({'idx':0, 'items': 0})
    if qf['idx'] == len(qf['items'])
        let paired_buf_ident = '!^'
    else
        let paired_buf = qf['items'][qf['idx']]['bufnr']
        let paired_buf_name = bufname(paired_buf)
        let paired_fug_data = FugitiveBufferIdent(paired_buf_name)
        if len(paired_fug_data) != 0
            let paired_buf_path = s:Slash(paired_fug_data[1][0:-6] . paired_fug_data[3])
            let paired_buf_ident = paired_fug_data[2] . ':' . paired_buf_path
            let g:ident = paired_buf_ident
        else
            let g:last_known = getqflist({'id':0, 'changedtick': 0, 'idx': 0})
            return
        endif
    endif
    only
    cw
    wincmd w
    cc
    exec 'Gdiffsplit ' . paired_buf_ident
    silent! call NormalizeWhitespace()
    wincmd w
    silent! call NormalizeWhitespace()
endfunc
function! NormalizeWhitespace()
    let oldmodifiable = &modifiable
    let oldreadonly = &readonly
    let oldwinid = win_getid()
    set modifiable
    set noreadonly
    let buf = getline(1, '$')
    let ft= &ft
    vsplit enew
    call setline(1, buf)
    let &ft = ft
    sleep 100m
    retab
    sleep 10m
    %s/^\s*\n\|\s*$//
    sleep 10m
    call CocAction("format")
    let buf = getline(1, '$')
    bw!
    0,$d
    call setline(1, buf)
    set nomodified
    let &modifiable = oldmodifiable
    let &readonly = oldreadonly
    call win_gotoid(oldwinid)
endfunc
function! s:Slash(path) abort
  if exists('+shellslash')
    return tr(a:path, '\', '/')
  else
    return a:path
  endif
endfunction
command! -bang -range=% -nargs=? Flog call LineLog(<bang>0, '<line1>', '<line2>', '<args>')
function! LineLog(bang, top, bot, a)
    vs
    let file = expand("%:p")
    let cmd = 'git log -w'
    if !empty(a:a)
        let cmd .= " -S" . a:a
    endif
    if a:top != 1 || a:bot != line("$")
        let cmd .= ' -L '. a:top . ',' . a:bot . ':' . file
    else
        let cmd .= ' -p '.  file
    endif
    if !a:bang
        echo cmd
        call Git_dir('term ' . cmd)
        norm! i
    else
        call Git_dir('term')
        call feedkeys("i" . cmd, 'n')
    endif
endfunc
function! Git_dir(command)
    let l:old_cd = getcwd()
    let l:new_root = FugitiveWorkTree()
    if ('' == l:new_root)
        let l:new_root = l:old_cd
    endif
    execute 'lcd '.l:new_root
    execute a:command
    execute 'lcd '.l:old_cd
endfunction
vnoremap dp :diffput<cr>
vnoremap do :diffget<cr>
vmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(LiveEasyAlign)
vmap <leader>r <Plug>(LiveEasyAlign)
nnoremap <a-j> <c-e>
nnoremap <a-k> <c-y>

