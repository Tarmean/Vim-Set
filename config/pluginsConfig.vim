command! DeopleteEnable call deoplete#enable()
command! DeopleteDisable call deoplete#disable()
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

inoremap <expr><C-g>     deoplete#mappings#undo_completion()

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
let g:racer_cmd = "/home/cyril/.cargo/bin/racer"
let $RUST_SRC_PATH="/home/cyril/rustc-1.9.0/src/"
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

let g:gitgutter_map_keys = 0
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

nmap <Leader>gp <Plug>GitGutterStageHunk
nmap <Leader>go <Plug>GitGutterUndoHunk
nmap <Leader>gP <Plug>GitGutterPreviewHunk
omap ix <Plug>GitGutterTextObjectInnerPending
omap ax <Plug>GitGutterTextObjectOuterPending
xmap ix <Plug>GitGutterTextObjectInnerVisual
xmap ax <Plug>GitGutterTextObjectOuterVisual

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


noremap <silent> - :call Dirvish_wrap_up('%')<cr>
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
func! Dirvish_wrap_up(path) " automatically seek the directory or file when going up
    let loc = escape(bufname("%"), '\')
    silent! execute "Dirvish " . a:path
    execute "lcd ".a:path
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

autocmd FileType java let b:syntastic_mode="passive"

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

noremap ]oz :Goyo!<cr>
noremap [oz :Goyo<cr>:IndentLinesDisable<cr>
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

let gutentags_ctags_tagfile=".git/tags"

let g:sneak#streak=1
let g:sneak#streak_esc = "\<esc>"
let g:sneak#s_next=1
let g:sneak#textobj_z=0
let g:sneak#use_ic_scs = 1
nmap f <Plug>Sneak_f
lmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
nmap ö <Plug>Sneak_s
nmap Ö <Plug>Sneak_S
"" visual-mode
xmap ö <Plug>Sneak_s
xmap Ö <Plug>Sneak_S
"" operator-pending-mode
omap ö <Plug>Sneak_s
omap Ö <Plug>Sneak_S

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

      " \ 'colorscheme': 'solarized_light',
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'GitStatus' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo', 'percent' ],
      \              [ 'neomake' , 'syntastic'],
      \              [ 'tags' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'neomake': 'neomake#statusline#LoclistStatus',
      \   'GitStatus': 'GitStatus',
      \ },
      \ 'component': {
      \   'tags':     '%{gutentags#statusline("[tags]")}',
      \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'},
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
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

if(has('unix'))
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

    function! Git_dir(command)
        cd %:h
        execute a:command
        cd -
    endfunction

    let g:fzf_layout = { 'window': 'enew' }

    autocmd! User FzfStatusLine call <SID>fzf_statusline()
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

    nnoremap <silent> <leader><leader> :call Git_dir("GitFiles")<cr>

    nnoremap <silent> <leader>fa :call Git_dir("GitStatus")<cr>
    nnoremap <silent> <leader>fm :Marks<cr>
    nnoremap <silent> <leader>ff :Buffers<cr>
    nnoremap <silent> <leader>fc :Commands<cr>
    nnoremap <silent> <leader>fl :BLines<cr>
    nnoremap <silent> <leader>fL :Lines<cr>
    nnoremap <silent> <leader>fd :call Tag_or_reload("Tags")<cr>
    nnoremap <silent> <leader>d :call Tag_or_reload("BTags")<cr>
    nnoremap <silent> <leader>fw :Windows<cr>
    nnoremap <silent> <leader>fj :Locate ~<cr>
    nnoremap <silent> <leader>fö :Locate ~/vimfiles/plugged/<cr>
    nnoremap <silent> <leader>fs :FASD<cr>
    nnoremap <silent> <leader>fS :History<cr>
    nnoremap <silent> <leader>fk :Snippets<cr>
    nnoremap <silent> <leader>fg :call Git_dir("Commits")<cr>
    nnoremap <silent> <leader>fG :call Git_dir("BCommits")<cr>
    nnoremap <silent> <leader>fh :Helptags<cr>

else
    nnoremap <leader>fJ :Unite -buffer-name=files   -start-insert file_rec:!<cr>
    nnoremap <leader>fj :<C-u>Unite -buffer-name=files   -start-insert file<cr>
    nnoremap <leader>fs :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
    nnoremap <leader>fd :<C-u>Unite -buffer-name=tags     -start-insert tag<cr>
    nnoremap <leader>fk :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
    nnoremap <leader>fy :<C-u>Unite -buffer-name=yank    history/yank<cr>
    nnoremap <leader>ff :<C-u>Unite -buffer-name=buffer  buffer<cr>
    nnoremap <leader>fl :<C-u>Unite -buffer-name=buffer -start-insert -no-split line<cr>
    autocmd FileType unite call s:unite_settings()
    function! s:unite_settings()
        let b:SuperTabDisabled=1
        imap <buffer> <C-j>   <Plug>(unite_select_next_line)
        imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
        nmap <buffer> <esc>   <Plug>(unite_exit)
        map <buffer> <leader><c>   <Plug>(unite_exit)
    endfunction
endif


function! SignifyUpdate(b)
    if(a:b)
        let g:signify_cursorhold_insert=1
        let g:signify_cursorhold_normal=1
        let g:signify_update_on_bufenter=1
        let g:signify_update_on_focusgained=1
        call SignifyAutocommands()
        return
    endif
    let g:signify_cursorhold_insert=0
    let g:signify_cursorhold_normal=0
    let g:signify_update_on_bufenter=0
    let g:signify_update_on_focusgained=0
    call SignifyAutocommands()
    return
endfunction

noremap [oG :call SignifyUpdate(1)<cr>
noremap ]oG :call SignifyUpdate(0)<cr>
noremap [og :SignifyToggle<cr>
noremap ]og :SignifyToggleHighlight<cr>:noh<esc>
omap ix <plug>(signify-motion-inner-pending)
xmap ix <plug>(signify-motion-inner-visual)
omap ax <plug>(signify-motion-outer-pending)
xmap ax <plug>(signify-motion-outer-visual)

let g:signify_vcs_list = ['git']


cabbrev git Git
nnoremap <space>ga :execute 'Git add ' . expand('%:p')<CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q %:p<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
noremap <space>gf :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gb :Git branch<Space>
nnoremap <space>gB :Gblame<CR>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>ggP :Dispatch! git push<CR>
nnoremap <space>ggp :Dispatch! git pull<CR>
vnoremap dp :diffput<cr>
vnoremap do :diffget<cr>

nnoremap <leader>gV :Gitv --all<cr>
nnoremap <leader>gv :Gitv! --all<cr>
vnoremap <leader>gv :Gitv! --all<cr>


