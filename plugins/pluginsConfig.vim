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


" let g:ulti_expand_or_jump_res = 0 "default value, just set once
" function! Ulti_ExpandOrJump_and_getRes()
"  call UltiSnips#ExpandSnippetOrJump()
"  return g:ulti_expand_or_jump_res
" endfunction


" inoremap <NL> <C-R>=(Ulti_ExpandOrJump_and_getRes() > 0)?"":IMAP_Jumpfunc('', 0)<CR>

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


" let g:splitjoin_split_mapping = ''
" let g:splitjoin_join_mapping = ''
" nmap K :SplitjoinJoin<cr>
" nmap J :SplitjoinSplit<cr>

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

let gutentags_tagfile=".git/tags"

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

	" let g:syntastic_mode_map = { 'mode': 'passive' }
	" augroup AutoSyntastic
	"   autocmd!
	"   autocmd BufWritePost *.c,*.cpp call s:syntastic()
	" augroup END
	" function! s:syntastic()
	"   SyntasticCheck
	"   call lightline#update()
	" endfunction
    " function! GitStatus() " {{{
    "     let branch =  winwidth(0) > 70 ?  gita#statusline#format(' %lb%{ ⇄ |}rn%{/|}rb') : ''
    "     let traffic =  winwidth(0) > 70 ?  gita#statusline#format('%{￩| }ic%{￫}og') : ''
    "     "return winwidth(0) > 70 ?  gita#statusline#format('%{!| }nc%{+| }na%{-| }nd%{"| }nr%{*| }nm%{@|}nu') : ''
    "     " b! clean ✔
    "     " i? staged, unstaged, both ● ✚
    "     " b! branch, remote, detached head  ➦ ⇄
    "     " i! diverged ￩ ￫
    "     " b? conflicted
    "     " i stash ⚑
    "     " b! merging(.git/MERGE_HEAD), rebasing(.git/rebase, ./rebase-apply,
    "     " .git/rebase-merge, .git/../.dotest), bisecting(.git/BISECT_LOG)
    "     "OK  added, deleted, renamed, modified + - ±
    "     if(strlen(l:branch)>0&&strlen(l:traffic)>0)
    "         let branch .= " "
    "     endif
    "     let branch .= traffic
    "     return branch
    " endfunction " }}}
" "  | |    ✚  ● ♻	♼  ⚝ ➦ ⚑ ⚐ ± ⚠ ☿ … ⇄ ￩ ￫ ✓ ✔ ✕ ✖ ✗ ✘ ⚡  ❌"
" " …  ⚡"

" configure with the followings (default values are shown below)
let unified_diff#executable = 'git'
let unified_diff#arguments = [
            \   'diff', '--no-index', '--no-color', '--no-ext-diff', '--unified=0',
            \ ]
let unified_diff#iwhite_arguments = [
            \   '--ignore--all-space',
            \ ]

let g:splice_prefix = "+"




