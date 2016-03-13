" ycm
if !exists('g:ycm_semantic_triggers')
let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
    \ ]

"vimtex
let g:vimtex_latexmk_progname="nvr"

"multicursor
let g:multi_cursor_insert_maps = {}
let g:multi_cursor_normal_maps= {'!':1, '@':1, '=':1, 'q':1, 'r':1, 't':1, 'T':1, 'y':1, '[':1, ']':1, '\':1, 'd':1, 'f':1, 'F':1, 'g':1, '"':1, 'z':1, 'c':1, 'm':1, '<':1, '>':1}

"jedi
let g:jedi#use_tag_stack = 0
autocmd FileType python nnoremap <buffer> <leader>a :call jedi#goto()<cr>
autocmd FileType python nnoremap <buffer> <leader>n :call jedi#show_documentation()<cr>
autocmd FileType python nnoremap <buffer> <leader><cr> :call jedi#usages()<cr>

"textobj column
let g:skip_default_textobj_word_column_mappings=1
nnoremap <silent> vav :call TextObjWordBasedColumn("aw")<cr>
nnoremap <silent> vaV :call TextObjWordBasedColumn("aW")<cr>
nnoremap <silent> viv :call TextObjWordBasedColumn("iw")<cr>
nnoremap <silent> viV :call TextObjWordBasedColumn("iW")<cr>
onoremap <silent> av  :call TextObjWordBasedColumn("aw")<cr>
onoremap <silent> aV  :call TextObjWordBasedColumn("aW")<cr>
onoremap <silent> iv  :call TextObjWordBasedColumn("iw")<cr>
onoremap <silent> iV  :call TextObjWordBasedColumn("iW")<cr>

