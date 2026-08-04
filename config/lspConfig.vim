" LSP / editor / debugger keymaps.
" LSP + completion + treesitter live in lua; sourced here (nvim only).
if has('nvim')
    luafile ~/vimfiles/config/lsp.lua
endif

set updatetime=300

" Highlight all occurrences of the word under the cursor.
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

" jdtls uses a jdt:// URI scheme for classfile buffers
au BufNew jdt://* set noswapfile


" ---------------------------------------------------------------------------
" Vimspector (debugger) mappings
" ---------------------------------------------------------------------------
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
