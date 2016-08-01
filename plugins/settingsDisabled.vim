" ycm
if !exists('g:ycm_semantic_triggers')
let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
    \ ]

"vimtex
let g:vimtex_latexmk_progname="nvr"

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

