" Use <c-space> to trigger completion.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(0) :
      \ (copilot#GetDisplayedSuggestion().text != "") ? copilot#Accept() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <a-cr> (copilot#GetDisplayedSuggestion().text == "") ? DoCopilotSuggest() : copilot#Accept()

function! DoCopilotSuggest()
    call feedkeys("\<Plug>(copilot-suggest)")
    return ""
endfunc


inoremap <silent><expr> <s-TAB> coc#pum#prev(0)
nmap gK <Plug>(coc-float-jump)
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"


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
nnoremap <localleader>f  :call CocAction('format')<cr>
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
    if (&filetype =~? '.*\(typescript\|javascript\).*')
      nmap <buffer> <silent> gD :CocCommand tsserver.goToSourceDefinition<cr>
    endif
    if (&filetype =~? 'java\|class')
        nmap <buffer> <silent> gu :CocCommand java.action.navigateToSuperImplementation<cr>
    else
        nmap <buffer> <silent> gu <Plug>(coc-declaration)
    endif

    nmap <buffer> <silent> gy <Plug>(coc-type-definition)
    nmap <buffer> <silent> gi <Plug>(coc-implementation)
    nmap <buffer> <silent> gr <Plug>(coc-references)
    nmap <buffer> <silent> gR <Plug>(coc-references-used)
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
nnoremap <silent> <leader>S  :<C-u>CocList symbols<cr>
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

xmap io <Plug>(coc-classobj-i)
xmap ao <Plug>(coc-classobj-a)
omap io <Plug>(coc-classobj-i)
omap ao <Plug>(coc-classobj-a)
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



nmap [b <Plug>VimspectorJumpToPreviousBreakpoint
nmap ]b <Plug>VimspectorJumpToNextBreakpoint
nmap ,dh <Plug>VimspectorJumpToProgramCounter

nmap <localleader>db <Plug>VimspectorToggleBreakpoint
nmap <localleader>dp <Plug>VimspectorPause
nmap <localleader>dq <Plug>VimspectorClose
nmap <localleader>dk <Plug>VimspectorStepOut
nmap <localleader>dj <Plug>VimspectorStepInto
nmap <localleader>df <Plug>VimspectorGotoCurrentLine
nmap <localleader>dl <Plug>VimspectorStepOver
nmap <localleader>dL <Plug>VimspectorRunToCursor
nmap <localleader>da <Plug>VimspectorDisassemble
nmap <localleader>dB <Plug>VimspectorBreakpoints
nmap <localleader>d? <Plug>VimspectorToggleConditionalBreakpoint
nmap <localleader>df <Plug>VimspectorAddFunctionBreakpoint
nmap <localleader>h <Plug>VimspectorGoToCurrentLine
nmap <localleader>dG <Plug>VimspectorContinue
nmap <localleader>dgg <Plug>VimspectorRestart

nmap <localleader>dd <Plug>VimspectorBalloonEval
xmap <localleader>dd <Plug>VimspectorBalloonEval

nmap <localleader>do <Plug>VimspectorUpFrame
nmap <localleader>di <Plug>VimspectorDownFrame


au BufNew jdt://* set noswapfile
