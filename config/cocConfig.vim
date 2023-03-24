" Use <c-space> to trigger completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent> <s-TAB> <C-p>
nmap gK <Plug>(coc-float-jump)
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


nmap <localleader>r <Plug>(coc-rename)
nmap <silent> <localleader>R <Plug>(coc-refactor)

nmap <silent> <c-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <c-j> <Plug>(coc-diagnostic-next)
nmap <silent> <tab> v<Plug>(coc-codeaction-selected)
vmap <silent> <tab> <Plug>(coc-codeaction-selected)
nmap <silent> <localleader>a  <Plug>(coc-codeaction)

augroup HaskellFixTab
    au!
    au BufReadPost *.hs nmap <buffer> <silent> <tab> v<Plug>(coc-codeaction-selected)
augroup END

nmap <s-tab>  <Plug>(coc-codelens-action)
vmap <s-tab>  <Plug>(coc-codelens-action)
nmap <localleader>f  <Plug>(coc-format-selected)
vmap <localleader>f  <Plug>(coc-format-selected)

let s:supported = ['php', 'haskell']
let s:fast = ['php']
nnoremap ga :call HighlightWord()<cr>
function! HighlightWord()
    let @/ = '\<' . expand('<cword>') . '\>'
    call feedkeys(":setlocal hls\r", 'n')
endfunc
function! Get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
function! s:BufferConfig()
    " Remap keys for gotos
    nmap <buffer> <silent> gd <Plug>(coc-definition)
    nmap <buffer> <silent> gD <Plug>(coc-declaration)
    nmap <buffer> <silent> gy <Plug>(coc-type-definition)
    nmap <buffer> <silent> gi <Plug>(coc-implementation)
    nmap <buffer> <silent> gr <Plug>(coc-references)
    let l = index(s:fast, &filetype)
    if (l:l >= 0)
        augroup CursorHold
            au!
        augroup END
    endif
endfunc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<c-j>'

augroup CocBufferConfig 
    au!
    au FileType * call s:BufferConfig()
    au CocBufferConfig CursorHold * silent! call CocActionAsync('highlight')
augroup END


" Remap for format selected region

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType php let b:coc_root_patterns = ['.git', '.env']
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END


" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
set updatetime=300


" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nnoremap <silent> <a-cr>  :<C-u>CocList actions<cr>
nnoremap <silent> <leader>d  :<C-u>CocList diagnostics<cr>
" Show commands
" Find symbol of current document
nnoremap <silent> <leader>s  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <localleader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <localleader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <localleader>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <localleader>l  :<C-u>CocListResume<CR>
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)


" Use K to show documentation in preview window
nnoremap <silent> K :call cocConfig#show_documentation()<CR>

function! cocConfig#show_documentation()
  if (index(['help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

nnoremap <silent> [C :CocFirst
nnoremap <silent> [c :CocPrev
nnoremap <silent> ]c :CocNext
nnoremap <silent> ]C :CocLast
