
" CHAR	 any non-blank character
" WORD	 a sequence of non-blank characters
" N	 a number entered before the command
" {motion} a cursor movement command
" Nmove	 the text that is moved over with a {motion}
" SECTION	 a section that possibly starts with '}' instead of '{'

" note: 1 = cursor movement command; 2 = can be undone/redone
"
let s:regex = '^|\([^:].*\)|	\([^	]\+\)	\+\(\d	\+\)\?\(.*\)$'
let s:Builtins = {}
let s:builtinBuffer = []
function! collect_builtins#add_match(tag, command, note, description)
    if a:description =~# "^commands starting with"
        return
    endif

    let tag = a:tag
    " let [mode, tag] = s:getMode(a:tag)
    let description_cleaned = substitute(a:description,  "\n	*", " ", "g")
    let identifier = substitute(description_cleaned, '^same as "\?\(.\{-\}\)"\?$', '\1', "")

    " vim doesn't allow for recursive substitution expressions.
    " it also would be a giant pain to parse the index without substitution
    " expressions so here I have to cheat in some other way
    let trigger = substitute(a:command, '^CTRL-\(.\)', '<C-\1>', 'g')
    let trigger = '"'.escape(trigger, '"<\').'"'
    let trigger = substitute(trigger, '{.\{-\}}', "", "g")
    let trigger = substitute(trigger, ' ', '', "g")
    let trigger = substitute(trigger, '\["x\]', '', "g")


    let alias = identifier != description_cleaned
    if !alias
        let identifier = tag
    else
        let description_cleaned = ''
    endif

    if has_key(s:Builtins, identifier) 
        " fun fact, viml has no short circuit evaluation
        " if has_key(s:Builtins[identifier], mode)
        call add(s:Builtins[identifier].triggers, [a:command, trigger])
        if !alias && s:Builtins[identifier].description != description_cleaned && description_cleaned != '"'
            " add the description
            if len(s:Builtins[identifier].description) > 0
                let description_cleaned = "; " . description_cleaned
            endif
            let s:Builtins[identifier].description .= description_cleaned 
        endif
        return
    endif
    let s:Builtins[identifier] = {
                                    \"triggers": [[a:command, trigger]],
                                    \"note": a:note,
                                    \"description": description_cleaned
                                 \}
endfunction
function! collect_builtins#collect()
    execute ':%s/' . s:regex . '/\=collect_builtins#add_match(submatch(1),submatch(2),submatch(3),submatch(4))/gn'
    let result = string(s:Builtins)
    let @" = substitute(result, "'\\(\".\\{-\\}\"\\)'", '\1', 'g')

endfunction

" function! s:getMode(tag)
" 	if a:tag =~# "^i_"
" 		return ['i', a:tag[2:-1]]
" 	elseif a:tag =~# "^v_"
" 		return ['v', a:tag[2:-1]]
" 	elseif a:tag =~# "^c_"
" 		return ['c', a:tag[2:-1]]
" 	else
" 		return ['n', a:tag]
" 	endif
" endfunction
