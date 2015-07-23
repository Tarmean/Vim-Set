nmap _  <Plug>ReplaceWithRegisterOperator

nnoremap [w :Obsession<CR>
nnoremap ]w :Obsession!<CR>

let g:prosession_on_startup = 0
noremap <leader>w :Prosession 
noremap <leader>W :Createsession 

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
			\ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''


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
noremap [ov :LengthmattersEnable<cr>
noremap ]ov :LengthmattersDisable<cr>
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
