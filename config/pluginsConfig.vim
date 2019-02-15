augroup Rust
    au!
    au FileType rust nnoremap <buffer> <silent> K :call LanguageClient_textDocument_hover()<CR>
    au FileType rust nnoremap <buffer> <silent> gd :call LanguageClient_textDocument_definition()<CR>
    au FileType rust nnoremap <buffer> <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
augroup END

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'php': ['php', '/vendor/felixfbecker/language-server/bin/php-language-server.php'],
    \ 'haskell': ['/home/cyril/.stack/compiler-tools/x86_64-linux/ghc-8.6.2/bin/hie-wrapper']
    \ }



nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround

"command! DeopleteEnable call deoplete#enable()
"command! DeopleteDisable call deoplete#disable()
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

"let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
"let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
"let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
"let g:deoplete#omni#functions.markdown = 'htmlcomplete#CompleteTags'
"" let g:deoplete#omni#functions.javascript =
""	\ [ 'tern#Complete', 'jspc#omni', 'javascriptcomplete#CompleteJS' ]
"" Difference: omni_patterns replaces deoplete features with vim's omni complete
"" omni#input_patterns polls the omni func as additional source

"let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
"let g:deoplete#omni_patterns.html = '<[^>]*'
"" let g:deoplete#omni_patterns.javascript = '[^. *\t]\.\w*'
"" let g:deoplete#omni_patterns.javascript = '[^. \t]\.\%\(\h\w*\)\?'
"let g:deoplete#omni_patterns.php =
"	\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

"let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})
"let g:deoplete#omni#input_patterns.xml = '<[^>]*'
"let g:deoplete#omni#input_patterns.md = '<[^>]*'
"let g:deoplete#omni#input_patterns.css  = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
"let g:deoplete#omni#input_patterns.scss = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
"let g:deoplete#omni#input_patterns.sass = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
"let g:deoplete#omni#input_patterns.python = ''
"let g:deoplete#omni#input_patterns.javascript = ''

"call deoplete#custom#set('omni',          'mark', '⌾')
"call deoplete#custom#set('ternjs',        'mark', '⌁')
"call deoplete#custom#set('jedi',          'mark', '⌁')
"call deoplete#custom#set('vim',           'mark', '⌁')
"call deoplete#custom#set('ultisnips',     'mark', '⌘')
"call deoplete#custom#set('tag',           'mark', '⌦')
"call deoplete#custom#set('around',        'mark', '↻')
"call deoplete#custom#set('buffer',        'mark', 'ℬ')
"call deoplete#custom#set('tmux-complete', 'mark', '⊶')
"call deoplete#custom#set('syntax',        'mark', '♯')

"call deoplete#custom#set('vim',           'rank', 630)
"call deoplete#custom#set('ternjs',        'rank', 620)
"call deoplete#custom#set('jedi',          'rank', 610)
"call deoplete#custom#set('omni',          'rank', 600)
"call deoplete#custom#set('ultisnips',     'rank', 510)
"call deoplete#custom#set('member',        'rank', 500)
"call deoplete#custom#set('file_include',  'rank', 420)
"call deoplete#custom#set('file',          'rank', 410)
"call deoplete#custom#set('tag',           'rank', 400)
"call deoplete#custom#set('around',        'rank', 330)
"call deoplete#custom#set('buffer',        'rank', 320)
"call deoplete#custom#set('dictionary',    'rank', 310)
"call deoplete#custom#set('tmux-complete', 'rank', 300)
"call deoplete#custom#set('syntax',        'rank', 200)

"call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])

"augroup DeopleteCustom
"    au!
"    autocmd CompleteDone * silent! pclose!
"augroup END

"let g:ulti_expand_or_jump_res = 0 "default value, just set once
"function! Ulti_ExpandOrJump_and_getRes()
" call UltiSnips#ExpandSnippetOrJump()
" return g:ulti_expand_or_jump_res
"endfunction


" smap <silent><expr><Tab> pumvisible() ? "\<Down>"
" 	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
" 	\ : (<SID>is_whitespace() ? "\<Tab>"
" 	\ : deoplete#manual_complete()))

" inoremap <expr><S-Tab>  pumvisible() ? "\<Up>" : "\<C-h>"

" function! s:is_whitespace()
" 	let col = col('.') - 1
" 	return ! col || getline('.')[col - 1] =~? '\s'
" endfunction

" inoremap <expr><C-g> deoplete#mappings#undo_completion()


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

" let gutentags_ctags_tagfile=".git/tags"
let g:gutentags_cache_dir="~/.vim/tags/"

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

" nmap ö <Plug>Sneak_s
" nmap Ö <Plug>Sneak_S
" "" visual-mode
" xmap ö <Plug>Sneak_s
" xmap Ö <Plug>Sneak_S
" "" operator-pending-mode
" omap ö <Plug>Sneak_s
" omap Ö <Plug>Sneak_S

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
      \             [ 'GitStatus' ],
      \             [ 'readonly', 'filename', 'modified', 'fileformat'] ],
      \   'right': [ [ 'lineinfo', 'percent' ],
      \              [ 'neomake' , 'syntastic'],
      \              [ 'lang_server' ],
      \              [ 'filetype' ]] 
      \ },
      \ 'component_function': {
      \   'neomake': 'neomake#statusline#LoclistStatus',
      \   'GitStatus': 'GitStatus',
      \   'lang_server': 'LanguageClient#statusLine'
      \ },
      \ 'component': { 
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
" \   'tags':     '%{gutentags#statusline("[tags]")}',
augroup LightlineColorscheme
    autocmd!
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

    function! Git_dir(command)
        let l:old_cd = getcwd()
        let l:new_root = ProjectRootGet()
        if ('' == l:new_root)
            let l:new_root = l:old_cd
        endif
        execute 'cd '.l:new_root
        execute a:command
        execute 'cd '.l:old_cd
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
    nnoremap <silent> <leader>fd :call Tag_or_reload("Tags")<cr>
    nnoremap <silent> <leader>d :call Tag_or_reload("BTags")<cr>
    nnoremap <silent> <leader>fw :Windows<cr>
    nnoremap <silent> <leader>fj :call fzf#vim#locate("~")<cr>
    nnoremap <silent> <leader>fö :Locate ~/vimfiles/plugged/<cr>
    nnoremap <silent> <leader>fs :History<cr>
    nnoremap <silent> <leader>fk :Snippets<cr>
    nnoremap <silent> <leader>fg :call Git_dir("Commits")<cr>
    nnoremap <silent> <leader>fG :call Git_dir("BCommits")<cr>
    nnoremap <silent> <leader>fh :Helptags<cr>

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

vmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(EasyAlign)
nmap <leader>r <Plug>(LiveEasyAlign)
vmap <leader>r <Plug>(LiveEasyAlign)

let g:php_cs_fixer_path="/home/cyril/.composer/vendor/bin/php-cs-fixer fix "
func! PHPFixF()
    exec "w"
    echo system(g:php_cs_fixer_path . expand('%:p'))
    exec "e"
endfunc
function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    silent! nunmap <leader>s
    silent! nunmap <leader>a
    silent! nunmap <leader>d
    " silent! nunmap gd
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
    nnoremap <buffer> <silent> <leader>a :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> <leader>s :call LanguageClient#textDocument_references()<cr>
    nnoremap <buffer> <silent> <leader>m :call LanguageClient_contextMenu()<cr>
    nnoremap <buffer> <silent> <leader>d :call LanguageClient#textDocument_documentSymbol()<cr>
    " nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_documentHighlight()<cr>
    " nnoremap <buffer> <silent> <esc> :LanguageClient#clearDocumentHighlight()<cr><esc>
    " nnoremap <buffer> <silent> leader<mr> :call LanguageClient#textDocument_rename()<CR>
  endif
endfunction
autocmd FileType * call LC_maps()

command! PhpFix call PHPFixF()
if has("autocmd")
    augroup PLUG_CONFIG
        au!

        " autocmd BufWritePost *.php silent! call PHPFixF()
        if exists('+omnifunc') 
            autocmd Filetype *
                    \	if &omnifunc == "" |
                    \		setlocal omnifunc=syntaxcomplete#Complete |
                    \	endif
        endif
    augroup END
endif
