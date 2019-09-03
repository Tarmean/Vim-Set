" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

let s:supported = ['php', 'haskell']
let s:fast = ['php']
nnoremap ga :call HighlightWord()<cr>
function! HighlightWord()
    let @/ = '\<' . expand('<cword>') . '\>'
    call feedkeys(":setlocal hls\r", 'n')
endfunc
function! s:BufferConfig()
    " Remap keys for gotos
    nmap <buffer> <silent> gd <Plug>(coc-definition)
    nmap <buffer> <silent> gy <Plug>(coc-type-definition)
    nmap <buffer> <silent> gi <Plug>(coc-implementation)
    nmap <buffer> <silent> gr <Plug>(coc-references)
    let l = index(s:fast, &filetype)
    if (l:l >= 0)
        augroup CursorHold
            au!
        augroup END
    endif
    inoremap <buffer> <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
endfunc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
augroup CocBufferConfig 
    autocmd!
    au FileType * call s:BufferConfig()
    autocmd CursorHold  * silent call CocActionAsync('highlight')
augroup end

" Remap for rename current word
nmap <localleader>r <Plug>(coc-rename)
" Remap for do codeAction of current line
" nmap <localleader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <localleader>qf  <Plug>(coc-fix-current)

" Remap for format selected region
xmap <localleader>f  <Plug>(coc-format-selected)
nmap <localleader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType php let b:coc_root_patterns = ['.git', '.env']
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
set updatetime=300


" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nnoremap <silent> <localleader>a  :<C-u>CocList actions<cr>
nnoremap <silent> <localleader>d  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <localleader>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <localleader>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <localleader>s  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <localleader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <localleader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <localleader>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <localleader>l  :<C-u>CocListResume<CR>


" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
