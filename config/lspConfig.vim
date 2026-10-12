" LSP / editor / debugger keymaps.
" LSP + completion + treesitter live in lua; sourced here (nvim only).
if has('nvim')
    luafile ~/vimfiles/config/lsp.lua
    " Fuzzy symbol pickers (<leader>s / <leader>S). After lsp.lua: it builds on
    " both the LSP and the treesitter setup there.
    luafile ~/vimfiles/config/symbols.lua
    " Debugger, replaces vimspector.
    luafile ~/vimfiles/config/dap.lua
    " Java LSP. After dap.lua: jdt.ls carries its own debug adapter and
    " registers it with nvim-dap at attach time.
    luafile ~/vimfiles/config/java.lua
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
