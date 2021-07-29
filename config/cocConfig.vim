" Use <c-space> to trigger completion.
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
    inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()
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
nnoremap <silent> <localleader>d  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <localleader>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <localleader>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>d  :<C-u>CocList outline<cr>
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
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup Agda
    au!
    au BufNewfile,BufRead *.agda setf agda
    au FileType agda call SetupAgda()
augroup END

func! SetupAgda()
    " command! -buffer -nargs=0 Load call Load(0)
    " command! -buffer AgdaVersion call AgdaVersion(0)
    " command! -buffer Reload silent! make!|redraw!
    " command! -buffer RestartAgda exec s:python_cmd 'RestartAgda()'
    " command! -buffer ShowImplicitArguments exec s:python_cmd "sendCommand('ShowImplicitArgs True')"
    " command! -buffer HideImplicitArguments exec s:python_cmd "sendCommand('ShowImplicitArgs False')"
    " command! -buffer ToggleImplicitArguments exec s:python_cmd "sendCommand('ToggleImplicitArgs')"
    " command! -buffer Constraints exec s:python_cmd "sendCommand('Cmd_constraints')"
    " command! -buffer Metas exec s:python_cmd "sendCommand('Cmd_metas')"
    " command! -buffer SolveAll exec s:python_cmd "sendCommand('Cmd_solveAll')"
    " command! -buffer ShowModule call ShowModule(<args>)
    " command! -buffer WhyInScope call WhyInScope(<args>)
    " command! -buffer SetRewriteMode exec s:python_cmd "setRewriteMode('<args>')"
    " command! -buffer SetRewriteModeAsIs exec s:python_cmd "setRewriteMode('AsIs')"
    " command! -buffer SetRewriteModeNormalised exec s:python_cmd "setRewriteMode('Normalised')"
    " command! -buffer SetRewriteModeSimplified exec s:python_cmd "setRewriteMode('Simplified')"
    " command! -buffer SetRewriteModeHeadNormal exec s:python_cmd "setRewriteMode('HeadNormal')"
    " command! -buffer SetRewriteModeInstantiated exec s:python_cmd "setRewriteMode('Instantiated')"

    " " C-c C-l -> \l
    " nnoremap <buffer> <LocalLeader>l :Reload<CR>
    " " C-c C-d -> \t
    " nnoremap <buffer> <LocalLeader>t :call Infer()<CR>
    " " C-c C-r -> \r
    " nnoremap <buffer> <LocalLeader>r :call Refine("False")<CR>
    " nnoremap <buffer> <LocalLeader>R :call Refine("True")<CR>
    " " C-c C-space -> \g
    " nnoremap <buffer> <LocalLeader>g :call Give()<CR>
    " " C-c C-g -> \c
    " nnoremap <buffer> <LocalLeader>c :call MakeCase()<CR>
    " " C-c C-a -> \a
    " nnoremap <buffer> <LocalLeader>a :call Auto()<CR>
    " " C-c C-, -> \e
    " nnoremap <buffer> <LocalLeader>e :call Context()<CR>
    " " C-u C-c C-n -> \n
    " nnoremap <buffer> <LocalLeader>n :call Normalize("False")<CR>
    " " C-c C-n -> \N
    " nnoremap <buffer> <LocalLeader>N :call Normalize("True")<CR>
    " nnoremap <buffer> <LocalLeader>M :call ShowModule('')<CR>
    " " C-c C-w -> \y
    " nnoremap <buffer> <LocalLeader>y :call WhyInScope('')<CR>
    " nnoremap <buffer> <LocalLeader>h :call HelperFunction()<CR>
    " " M-. -> \d
    " nnoremap <buffer> <LocalLeader>d :call GotoAnnotation()<CR>
    " " C-c C-? -> \m
    " nnoremap <buffer> <LocalLeader>m :Metas<CR>

    " " Show/reload metas
    " " C-c C-? -> C-e
    " nnoremap <buffer> <C-e> :Metas<CR>
    " inoremap <buffer> <C-e> <C-o>:Metas<CR>

    " " Go to next/previous meta
    " " C-c C-f -> C-g
    " nnoremap <buffer> <silent> <C-g>  :let _s=@/<CR>/ {!\\| ?<CR>:let @/=_s<CR>2l
    " inoremap <buffer> <silent> <C-g>  <C-o>:let _s=@/<CR><C-o>/ {!\\| ?<CR><C-o>:let @/=_s<CR><C-o>2l

    " " C-c C-b -> C-y
    " nnoremap <buffer> <silent> <C-y>  2h:let _s=@/<CR>? {!\\| \?<CR>:let @/=_s<CR>2l
    " inoremap <buffer> <silent> <C-y>  <C-o>2h<C-o>:let _s=@/<CR><C-o>? {!\\| \?<CR><C-o>:let @/=_s<CR><C-o>2l
endfunc

nnoremap <silent> [C :CocFirst
nnoremap <silent> [c :CocPrev
nnoremap <silent> ]c :CocNext
nnoremap <silent> ]C :CocLast

" <leader>d to perform a pattern match, <leader>n to fill a hole
nnoremap <silent> <leader>w  :<C-u>set operatorfunc=<SID>WingmanDestruct<CR>g@l
nnoremap <silent> <leader>W  :<C-u>set operatorfunc=<SID>WingmanDestructAll<CR>g@l
nnoremap <silent> <leader>e  :<C-u>set operatorfunc=<SID>WingmanUseCtor<CR>g@l
nnoremap <silent> <leader>R  :<C-u>set operatorfunc=<SID>WingmanFillHole<CR>g@l
nnoremap <silent> <leader>r  :<C-u>set operatorfunc=<SID>WingmanRefine<CR>g@l


function! s:JumpToNextHole()
  call CocActionAsync('diagnosticNext')
endfunction

function! s:GotoNextHole()
  " wait for the hole diagnostics to reload
  sleep 500m
  " and then jump to the next hole
  normal 0
  call <SID>JumpToNextHole()
endfunction

function! s:WingmanRefine(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.refine'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanDestruct(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.caseSplit'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanDestructAll(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.splitFuncArgs'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanFillHole(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.fillHole'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanUseCtor(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.useConstructor'])
  call <SID>GotoNextHole()
endfunction
