" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<c-tab>"

let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0
map <space><c-j> :SidewaysLeft<cr>
map <space><c-k> :SidewaysRight<cr>
map <space><c-h> :SidewaysJumpLeft<cr>
map <space><c-l> :SidewaysJumpRight<cr>
" map <space><c-j> ]e
" map <space><c-k> [e
" vmap <space><c-j> ]egv
" vmap <space><c-k> [egv
let g:multi_cursor_insert_maps = {}
let g:multi_cursor_normal_maps= {'!':1, '@':1, '=':1, 'q':1, 'r':1, 't':1, 'T':1, 'y':1, '[':1, ']':1, '\':1, 'd':1, 'f':1, 'F':1, 'g':1, '"':1, 'z':1, 'c':1, 'm':1, '<':1, '>':1}
let g:fold_cycle_default_mapping = 0 "disable default mappings 
nmap <silent> <space>ü :<C-u>call fold_cycle#close()<CR>
nmap <silent> <space>ä :<C-u>call fold_cycle#open()<CR>
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nmap K :SplitjoinJoin<cr>
nmap J :SplitjoinSplit<cr>
let g:tf_workaround= 0

let g:jedi#use_tag_stack = 0
autocmd FileType python nnoremap <buffer> <leader>a :call jedi#goto()<cr>
autocmd FileType python nnoremap <buffer> <leader>n :call jedi#show_documentation()<cr>
autocmd FileType python nnoremap <buffer> <leader><cr> :call jedi#usages()<cr>

autocmd FileType java let b:syntastic_mode="passive"


if !has("nvim")
    " "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " " Disable AutoComplPop.
    " let g:acp_enableAtStartup = 0
    " " Use neocomplete.
    " let g:neocomplete#enable_at_startup = 1
    " " Use smartcase.
    " let g:neocomplete#enable_smart_case = 1
    " " Set minimum syntax keyword length.
    " let g:neocomplete#sources#syntax#min_keyword_length = 3
    " let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " " Define dictionary.
    " let g:neocomplete#sources#dictionary#dictionaries = {
    "     \ 'default' : '',
    "     \ 'text' : $HOME.'/vimfiles/UK.dict',
    "     \ 'vimshell' : $HOME.'/.vimshell_hist',
    "     \ 'scheme' : $HOME.'/.gosh_completions'
    "         \ }

    " " Define keyword.
    " if !exists('g:neocomplete#keyword_patterns')
    "     let g:neocomplete#keyword_patterns = {}
    " endif
    " let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " " Plugin key-mappings.
    " inoremap <expr><C-g>     neocomplete#undo_completion()
    " inoremap <expr><C-l>     neocomplete#complete_common_string()


    " " Recommended key-mappings.
    " " <CR>: close popup and save indent.
    " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    " function! s:my_cr_function()
    "   return neocomplete#close_popup() . "\<CR>"
    "   " For no inserting <CR> key.
    "   "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    " endfunction
    " " <TAB>: completion.
    " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " " <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    " inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " inoremap <expr><C-y>  neocomplete#close_popup()
    " inoremap <expr><C-e>  neocomplete#cancel_popup()
    " " Close popup by <Space>.
    " "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " " For cursor moving in insert mode(Not recommended)
    " "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    " "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    " "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    " "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " " Or set this.
    " "let g:neocomplete#enable_cursor_hold_i = 1
    " " Or set this.
    " "let g:neocomplete#enable_insert_char_pre = 1

    " " AutoComplPop like behavior.
    " "let g:neocomplete#enable_auto_select = 1


    " " Enable omni completion.
    " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " " Enable heavy omni completion.
    " if !exists('g:neocomplete#sources#omni#input_patterns')
    "   let g:neocomplete#sources#omni#input_patterns = {}
    " endif

    " "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    " "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    " "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " " For perlomni.vim setting.
    " " https://github.com/c9s/perlomni.vim
endif

let g:skip_default_textobj_word_column_mappings=1
nnoremap <silent> vav :call TextObjWordBasedColumn("aw")<cr>
nnoremap <silent> vaV :call TextObjWordBasedColumn("aW")<cr>
nnoremap <silent> viv :call TextObjWordBasedColumn("iw")<cr>
nnoremap <silent> viV :call TextObjWordBasedColumn("iW")<cr>
onoremap <silent> av  :call TextObjWordBasedColumn("aw")<cr>
onoremap <silent> aV  :call TextObjWordBasedColumn("aW")<cr>
onoremap <silent> iv  :call TextObjWordBasedColumn("iw")<cr>
onoremap <silent> iV  :call TextObjWordBasedColumn("iW")<cr>

let g:textobj_comment_no_default_key_mappings = 1
omap aC <Plug>(textobj-comment-big-a)
omap ac <Plug>(textobj-comment-a)
omap ic <Plug>(textobj-comment-i)
nmap vaC v<Plug>(textobj-comment-big-a)
nmap vac v<Plug>(textobj-comment-a)
nmap vic v<Plug>(textobj-comment-i)

nmap _  <Plug>ReplaceWithRegisterOperator
nmap __  <Plug>ReplaceWithRegisterOperatorik

noremap ]oz :Goyo!<cr>
noremap [oz :Goyo<cr>:IndentLinesDisable<cr>
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

let gutentags_tagfile=".git/tags"

let g:sneak#streak=1
let g:sneak#streak_esc = "\<esc>"
silent! unmap s
silent! unmap S
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

"function! g:UltiSnips_Complete()
"    call UltiSnips#ExpandSnippet()
"    if g:ulti_expand_res == 0
"        if pumvisible()
"            return "\<C-n>"
"        else
"            call UltiSnips#JumpForwards()
"            if g:ulti_jump_forwards_res == 0
"                return "\<tab>"
"            endif
"        endif
"    endif
"    return ""
"endfunction
"au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
"let g:UltiSnipsListSnippets="<c-e>"
"" this mapping Enter key to <C-y> to chose the current highlight item 
"" and close the selection list, same as other IDEs.
"" CONFLICT with some plugins like tpope/Endwise
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"let g:airline_theme='powerlineish'
"let g:airline_powerline_fonts = 1
"let g:airline_section_y = ''

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

	let g:syntastic_mode_map = { 'mode': 'passive' }
	augroup AutoSyntastic
	  autocmd!
	  autocmd BufWritePost *.c,*.cpp call s:syntastic()
	augroup END
	function! s:syntastic()
	  SyntasticCheck
	  call lightline#update()
	endfunction
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
      ""\   'gita': '%{gita#statusline#format("lb% ⇄ rb%  {￩ic%|}{￫og%|}")}',
"set diffexpr=unified_diff#diffexpr()

" configure with the followings (default values are shown below)
let unified_diff#executable = 'git'
let unified_diff#arguments = [
            \   'diff', '--no-index', '--no-color', '--no-ext-diff', '--unified=0',
            \ ]
let unified_diff#iwhite_arguments = [
            \   '--ignore--all-space',
            \ ]

let g:splice_prefix = "+"




nnoremap <leader>fb :FileBeagle<cr>
let g:filebeagle_show_hidden =  1

let delimitMate_expand_cr=1

nnoremap <leader>i gT
nnoremap <leader>I :<C-U>call Clone_rel_tab_backwards(1, v:count)<CR>
nnoremap <leader><c-I> :<C-U>call Clone_rel_tab_backwards(0, v:count)<CR>
nnoremap <leader>O :<C-U>call Clone_rel_tab_forwards(1, v:count)<CR>
nnoremap <leader><c-O> :<C-U>call Clone_rel_tab_forwards(0, v:count)<CR>
nnoremap <silent><leader>o :<C-U>call RelativeNext(v:count1)<CR>
noremap <silent><leader>h  : call WinMove('h')<cr>
noremap <silent><leader>k  : call WinMove('k')<cr>
noremap <silent><leader>l  : call WinMove('l')<cr>
noremap <silent><leader>j  : call WinMove('j')<cr>
noremap <silent><leader>H  : wincmd H<cr>
noremap <silent><leader>K  : wincmd K<cr>
noremap <silent><leader>L  : wincmd L<cr>
noremap <silent><leader>J  : wincmd J<cr>

noremap [oI :set autoindent<cr>
noremap ]oI :set noautoindent<cr>
noremap [oü :SetCharSwap 1<cr>
noremap ]oä :SetCharSwap 0<cr>
noremap ]oN :set foldcolumn=0<cr>
noremap [oN :set foldcolumn=4<cr>
noremap <silent> [oA :call SideLineToggle(1)<cr>
noremap <silent> ]oA :call SideLineToggle(0)<cr>
