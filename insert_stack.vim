func! s:setup()
    if !exists("b:state_stack")
        setlocal indentexpr=""
        setlocal nosmartindent
        setlocal nocindent
        setlocal noautoindent
        let b:state_stack = []
    endif
endfunc

let g:insert_stack#ft_mappings = {
\"nim":{
                         \            "when":  ["when ",  [{"default":[":", ">>"], ":": ": ", "==":[":", ">>"]}, {"elif": ["elif"], "else": ["else"]}]],
                         \            "if":    ["if ",    [{"default":[":", ">>"], ":": ": ", "==":[":", ">>"]}, {"elif": ["elif"], "else": ["else"]}]],
                         \            "elif":  ["elif ",  [{"default":[":", ""], ":": ": ", "==":[":", ">>"]}, {"elif": ["elif"], "else": ["else"]}]],
                         \            "else":  [["else:", "=="], []],
                         \            "while": ["while ", [{"default":[":", ">>"], ":": ": ", "==":[":", ">>"]}]],
                         \            "block": ["block ", [{"default":[":", ">>"], ":": ": ", "==":[":", ">>"]}]],
                         \            "case":  ["case ",  [{":": ": "}, {"==": ["==", "of"], "of":["==", "of"], "default":["==", "of"] }]],
                         \            "of":    ["of ",    [":",  {"==":">>", "default": ">>"}, {"of": "of", "else": "else"}]],
                         \            "for":   ["for ",   [{"in":" in ", "default": " in "}, {"default":[":", ">>"], ":": ": ", "==":[":", ">>"]}]],
                         \            "param": ["", [{":": ": "}, {"=": "= "}, {",": [", ", "param"]}]],
                         \            "proc":  ["proc ",  [{"(": ["(", "param"], "default": "()"}, {":":": "}, {"default":[" =", ">>"], "==": [" =", ">>"]}]],
                         \            "let":   ["let ",   [{">>": ">>"}, {":": ":"}, "=", "=="]],
                         \            "var":   ["let ",   [{">>": ">>"}, {":": ":"}, {"=": "="}, "=="]],
\ }}

func! s:push_internal(mapping)
    if type(a:mapping[0]) == 1
        call feedkeys(a:mapping[0], "n")
    else 
        if type(a:mapping[0][0]) == 2
            call a:mapping[0][0](a:mapping[0][1])
        else 
            for map in a:mapping[0]
                call s:push(map)
            endfor
        endif 
    endif 
    let i = len(a:mapping[1])
    while i > 0
        let i -= 1
        call add(b:state_stack, a:mapping[1][i])
    endwhile
endfunc
func! Push(mapping)
    call s:setup()
    if !s:pop(a:mapping)
        call s:push(a:mapping)
    endif 
endfunc

func! s:push(mapping)
    if has_key(g:insert_stack#ft_mappings, &ft) && has_key(g:insert_stack#ft_mappings[&ft], a:mapping)
        call s:push_internal(g:insert_stack#ft_mappings[&ft][a:mapping])
    elseif has_key(g:default_mappings, a:mapping)
        call s:push_internal(g:default_mappings[a:mapping])
    else
        call feedkeys(a:mapping, "n")
    endif
endfunc
" augroup insert_stack
"     au!
"     au InsertLeave * call s:pop("")
" augroup END
" inoremap <esc> :call Pop("")<cr>
inoremap ö :call Push("")<Left><Left>
inoremap Ö :call Pop(-1)<cr>
inoremap <esc> :call Pop(-1)<cr>
inoremap # :call Debug()<cr>
func! Pop(times)
    if  a:times == -1
        if len(b:state_stack) > 1
            call s:pop_times(0, "default")
        endif
        call feedkeys("\<esc>", "n")
    else 
        if len(b:state_stack) > 1
            call s:pop_times(len(b:state_stack)-a:times-1, "default")
        endif 
    endif
endfunc


func! s:pop(mapping)
    let times = s:should_pop(a:mapping)
    if times >= 0
        call s:pop_times(times, a:mapping)
        return 1
    endif
endfunc
func! s:pop_times(start, mapping)
    let results = remove(b:state_stack, a:start, -1)
    let i =  len(results)
    while i > 0
        let i -= 1
        if type(results[i]) == 4 
            if has_key(results[i], a:mapping)
                call s:apply(results[i][a:mapping])
            elseif has_key(results[i], "default")
                call s:apply(results[i]["default"])
            endif
        else
            call s:apply(results[i])
        endif
    endwhile
endfunc
func! s:should_pop(mapping)
    let i = len(b:state_stack)
    while i > 0
        let i -= 1
        if (type(b:state_stack[i]) == 4 && has_key(b:state_stack[i], a:mapping)) || (type(b:state_stack[i]) == 1  && b:state_stack[i] ==# a:mapping)
            return i
        endif
    endwhile
    return -1
endfunc

func! s:apply(item)
    if type(a:item) == 1
        call s:push(a:item)
    elseif type(a:item) == 3
        if  type(a:item[0]) == 2
            call a:item[0](a:item[1])
        else 
            for i in a:item
                call s:push(i)
            endfor
        endif
    " elseif type(a:item) == 2
    endif
endfunc
func! Debug()
    echo b:state_stack
    call getchar()
endfunc

func! StayOrUpward()
    if getline() =~ "^\s*$"
        if !s:pop_one()
            return
        endif
    endif
    call feedkeys("\<cr>")
endfunc

func! MapInsert(maps)
     for [l, r] in a:maps
         exec "iunmap " . l
     endfor
     for [l, r] in a:maps
         exec "inoremap " . l . " :silent call Push('" . r . "')<cr>"
     endfor
 endfunc
call MapInsert([
          \ ["<cr>",   "=="],
          \ ["<a-cr>", "<<"],
          \ ["if",   "if"],
          \ ["elif",   "elif"],
          \ ["else",   "else"],
          \ ["proc", "proc"],
          \ ["in", "in"],
          \ ["while", "while"],
          \ ["for", "for"],
          \ ["case", "case"],
          \ ["of", "of"],
          \ [":",   ":"],
          \ ["(",   "("],
          \ [")",   ")"],
          \ ["[",   "["],
          \ ["]",   "]"],
          \ ["<",   "<"],
          \ [">",   ">"],
          \ ['"',   '""'],
          \ [',',   ','],
          \ ["+",   "<pop>"],
         \])
func! CopyIndent(times)
  let indent = float2nr(ceil(indent(".") / &shiftwidth) + a:times)
  call feedkeys("\<cr>", "n")
  for i in range(1, indent)
      call feedkeys("\<C-T>", "n")
  endfor
endfunc
let Cindent = function("CopyIndent")
            
let g:default_mappings = {
                         \            "<<":   [[Cindent, -1], []],
                         \            ">>":   [[Cindent, 1], [{"<<": "<<", "<-": "<-", "default": "<-"}]],
                         \            "->":   ["\<C-T>", []],
                         \            "<-":   ["\<C-D>", []],
                         \            "==":   [[Cindent, 0], []],
                         \            "<pop>":[":call Pop(1)\<cr>", []],
                         \            "<>":   ["", [{"==":  ["==", "<pop>"], "<<": ["==", "<>"]}]],
                         \            "(":    ["(", [{"<<": [">>", "->", "<>"]}, ")"]],
                         \            "{":    ["{", [{"<<": [">>", "->", "<>"]}, "}"]],
                         \            "[":    ["[", [{"<<": [">>", "->", "<>"]}, "]"]],
                         \            '""':    ['"', ['"']],
                         \}
