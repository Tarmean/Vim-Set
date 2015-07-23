
let g:textobj_comment_no_default_key_mappings = 1
xmap aC <Plug>(textobj-comment-a)
omap aC <Plug>(textobj-comment-a)
xmap iC <Plug>(textobj-comment-i)
omap iC <Plug>(textobj-comment-i)

noremap ]oz :Goyo!<cr>
noremap [oz :Goyo<cr>:IndentLinesDisable<cr>
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

let g:sneak#streak=1
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
" visual-mode
xmap ö <Plug>Sneak_s
xmap Ö <Plug>Sneak_S
" operator-pending-mode
omap ö <Plug>Sneak_s
omap Ö <Plug>Sneak_S


nnoremap [w :Obsession<CR>
nnoremap ]w :Obsession!<CR>

noremap <space>Y <Plug>(operator-grex-yank)
noremap <space>X <Plug>(operator-grex-delete)
noremap _  <Plug>(operator-replace)

let g:prosession_on_startup = 0
noremap <leader>w :Prosession 
noremap <leader>W :Createsession 

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
            \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

"let g:airline_theme='powerlineish'
"let g:airline_powerline_fonts = 1
"let g:airline_section_y = ''
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'GitStatus'],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo', 'percent' ],
      \              [ 'neomake' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'neomake': 'neomake#statusline#LoclistStatus',
      \   'GitStatus': 'GitStatus',
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'},
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'lineinfo': '(winwidth(0) >= 70)',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

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

    " function! GitStatus() " {{{
    "     let branch =  winwidth(0) > 70 ?  gita#statusline#format(' %lb%{ ⇄ |}rn%{/|}rb') : ''
    "     let traffic =  winwidth(0) > 70 ?  gita#statusline#format('%{￩| }ic%{￫}og') : ''
    "     "return winwidth(0) > 70 ?  gita#statusline#format('%{!| }nc%{+| }na%{-| }nd%{"| }nr%{*| }nm%{@|}nu') : ''
    "     " b! clean ✔
    "     " i? staged, unstaged, both ● ✚
    "     " b! branch, remote, detached head  ➦ ⇄
    "     " i! diverged ￩ ￫
    "     " b? conflicted ❌
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
xnoremap dp :diffput<cr>
xnoremap do :diffget<cr>

nnoremap <leader>gV :Gitv --all<cr>
nnoremap <leader>gv :Gitv! --all<cr>
vnoremap <leader>gv :Gitv! --all<cr>

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
noremap [oc :call SeoulInc()<cr>
noremap ]oc :call SeoulDec()<cr>
noremap ]oC :colorscheme molokai<cr>
noremap [oC :colorscheme seoul256<cr>
noremap <silent> [oA :call SideLineToggle(1)<cr>
noremap <silent> ]oA :call SideLineToggle(0)<cr>


omap ix <plug>(signify-motion-inner-pending)
xmap ix <plug>(signify-motion-inner-visual)
omap ax <plug>(signify-motion-outer-pending)
xmap ax <plug>(signify-motion-outer-visual)
