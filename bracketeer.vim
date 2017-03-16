" "if" = "'if ' expr (': ' expr) / (':' >> stmt <<)"
" seq["if", expr, ord[seq[": ", expr], seq[":", >>, stmt, <<]]

" types:
"     lit
"     nonterminal
"     function
"     group
"     sequence
"     option
function! Parse_block(input)
        return 1
    endif
    return 98
endfunc

if "'a'" =~ "'a'"
    echo "a"
endif
if "a" =~ ".\{-}"
    echo "b"
endif
