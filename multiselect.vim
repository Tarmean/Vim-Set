"legacy{{{
let g:multiselect#prompt=">"
function! NoArea() "{{{
    norm vii
    norm ygv
    norm! .

    echom multiselect#getAreaOrMotion(0)
    "return multiselect#getAreaOrMotion(1)
endfunction "}}}
onoremap <silent> im :call NoArea()<cr>
function! multiselect#getAreaOrMotion(...) "{{{
    if a:0 == 0 || a:1
        let b1 = "'["
        let b2 = "']"
    else
        let b1 = "'<"
        let b2 = "'>"
    endif
    return ListToString(getpos(b1)) . " " . ListToString(getpos(b2))
endfunction
 "}}}
function! ListToString(list) "{{{
    let result = "["
    for entry in a:list[0:-2]
        let result = result . entry . ", "
    endfor
    let result = result . a:list[-1] . ""
    return result . "]"
endfunction
 "}}}
function! multiselect#getOmaps() "{{{
    let backup = @a
    redir @a
    silent! omap
    redir END
    let result = @a
    let @a = backup
    let lhsList = []
    let rhsList = []
    for line in split(result, "\n")
        let line = line[2:]
        let pair =  split(line, " ")
        let lhs = pair[0]
        call add(lhsList, lhs)
        let rhs = join(pair[1:-1])
        call add(rhsList, rhs)
    endfor
    return [lhsList, rhsList]
endfunction
 "}}}
let g:multiselect#multiselectpending=0 "{{{
augroup multiselect
    au!
    autocmd CursorMoved * call multiselect#test()
augroup end
 "}}}
function! multiselect#getSelected() "{{{
    return [[getpos("'<")[1:2], getpos("'>")[1:2]]]
endfunction
 "}}}
function! multiselect#test() "{{{
    if(g:multiselect#multiselectpending) 
        call TestA("line") 
    endif
endfunction
 "}}}
function! TestA(type) "{{{
    let g:multiselect#counter =0
    set operatorfunc=TestB
    norm! .
    set operatorfunc=TestA
    echo g:multiselect#counter
endfunction
function! TestB(type)
    let g:multiselect#counter += 1
endfunction "}}}"}}}

"Processing:{{{
function! multiselect#inittest() "{{{
    let curpos = getpos(".")
    call multiselect#readAndProcess(v:operator)
    call setpos(".", curpos)
    call setpos("'<", curpos)
    call setpos("'>", curpos)
endfunction
onoremap . :call multiselect#inittest()<cr>
xnoremap . :call multiselect#inittest()<cr>
"}}}
function! multiselect#readAndProcess(endCom) "{{{
    let visual = 0
    let reading = 1
    let area = [getpos(".")[1:2]]
    let promptbase = a:endCom . " . "
    while reading
        let  commandlist = multiselect#readOp(promptbase)
        if len(commandlist) == 2
            let [reading, command] = commandlist
            let promptbase = promptbase . command . " . "
        else
            let [reading, command, alias] = commandlist
            let promptbase = promptbase . alias . " . "
        endif
        if reading
            let result = multiselect#apply(command, area, visual)
            let [visual, area] = result
        elseif reading == -1
            norm v
            return
        endif
    endwhile
    call multiselect#applyCommand(a:endCom, area, visual)
endfunction







"}}}
function! multiselect#readOp(...) "{{{
    if a:0 == 0
        let base = ""
    else
        let base = a:1
    endif
    let [lhs, rhs] = multiselect#getOmaps()
    let reading = 1
    let i = 0
    let s = ""
    redraw | echo base . g:multiselect#prompt
    while 1
        "if sneak#util#isvisualop(a:mode) | exe 'norm! gv' | endif "preserve selection
        let c = sneak#util#getchar()
        if -1 != index(["\<esc>", "\<c-c>", "\<backspace>", "\<del>"], c)
            return [-1, s]
        endif
        if c == "\<CR>"
            if match(s, "^\/.\*$") == 0
                return [1, s."", s]
            endif
            if i > 1 "special case: accept the current input (#15)
                return [1, s]
            " else "special case: repeat the last search (useful for streak-mode).
            "     return s:st.input
            endif
            return [0, s]
        else
            let s .= c
            let i += 1
            " if 1 == &iminsert && sneak#util#strlen(s) >= a:n
            "     "HACK: this can happen if the user entered multiple characters while we
            "     "were waiting to resolve a multi-char keymap.
            "     "example for keymap 'bulgarian-phonetic':
            "     "    e:: => ё    | resolved, strwidth=1
            "     "    eo  => eo   | unresolved, strwidth=2
            "     break
            " endif
        endif
        let result = substitute(s, '^\d*\(.\{-}\)$', '\1', '')

        for mapping in lhs
            if result ==# mapping
                return [1, s]
            endif
        endfor
        redraw | echo base . g:multiselect#prompt . s
    endwhile
    return[0, s]
endfunction
"}}}
function! multiselect#applyCommand(command, areas, visual) "{{{
    let areas = reverse(a:areas)
    if a:visual
        norm! v
        for area in areas
            call setpos("'<", [0]+area[0]+[0])
            call setpos("'>", [0]+area[1]+[0])
            execute "norm gv".a:command
        endfor
    else
        for area in areas
            call setpos(".", [0]+area+[0])
            execute "norm ".a:command
        endfor
    endif
endfunction
"}}}
function! multiselect#chainMotions(commands, ...) "{{{
    let visual = 1
    let area = [[getpos("'<")[1:2], getpos("'>")[1:2]]]
    let forcevisual = 0
    for command in a:commands
        if command == "v"
            let forcevisual = !forcevisual
            continue
        endif
        let [visual, area] = multiselect#apply(command, area, visual)
    endfor
    return [visual, area]
endfunction
"}}}
function! multiselect#apply(command, areas, visual) "{{{
    let newAreas = []
    let newLocations = []
    let areaSelection = 0
    if a:visual
        for area in a:areas
            let [areaSelectionRel, result] = multiselect#applyArea(a:command, area)
            let areaSelection = areaSelection || areaSelectionRel
            if areaSelection
                let newAreas = newAreas + result
            else
                let newLocations = newLocations + result
            endif
            " echo areaSelection ? newAreas : newLocations
        endfor
    else
        for area in a:areas
            let [areaSelectionRel, result] = multiselect#applyPosition(a:command, area)
            let areaSelection = areaSelection || areaSelectionRel
            if areaSelection
                if(len(newAreas) == 0 || newAreas[-1] != result)
                    let newAreas = newAreas + [result]
                endif
            else
                if(len(newLocations) == 0 || newLocations[-1] != result)
                    let newLocations = newLocations + [result]
                endif
            endif
            " echo result
        endfor
    endif
    if areaSelection
        return [1, newAreas]
    else
        return [0, newLocations]
    endif
endfunction

 "}}}
function! multiselect#applyPosition(command, location) "{{{
    let [row, col] = a:location
    let startPos = [0, row, col, 0]
    call setpos(".", startPos)
    silent execute "norm v" . a:command . ""
    let curPos = getpos(".")
    let leftSelection =  getpos("'<")
    let rightSelection =  getpos("'>")
    let movLeft = leftSelection == curPos && rightSelection == startPos
    let movRight = leftSelection == startPos && rightSelection == curPos
    let shittyWordObjectHeuristic = (a:command[0] == 'a'|| a:command[0] == 'i')
    if (movLeft || movRight) && !shittyWordObjectHeuristic
        "movement to the left
        return [0, curPos[1:2]]
    else
        "textobject or visual selection
        return[1, [leftSelection[1:2], rightSelection[1:2]]]
    endif
endfunction
"}}}
function! multiselect#applyArea(command, ...) "{{{
    if a:0 == 0
        let visual = 0
        let area = [getpos("'<")[1:2], getpos("'>")[1:2]]
    elseif a:0 == 1
        let visual = 0
        let area = a:1
    else
        let visual = 1
        let area = a:1
        let movecommand = a:2
    endif
    " echo area

    let shittyWordObjectHeuristic = (a:command[0] == 'a'|| a:command[0] == 'i')
    let areaSelection = visual || shittyWordObjectHeuristic
    let inside = 1
    call setpos(".", [0] + area[0] + [0])
    let curPos = getpos(".")
    let startingPosition = getcurpos()
    let newLocations = []
    let newAreas = []
    while inside "{{{
        let oldCurPos = curPos
        silent execute "norm v" . a:command . ""
        let curPos = getpos(".")
        let leftSelection =  getpos("'<")
        let rightSelection =  getpos("'>")
        let movLeft = leftSelection == curPos && rightSelection == oldCurPos
        let movRight = leftSelection == oldCurPos && rightSelection == curPos
        let noMovement = multiselect#appendArea([leftSelection[1:2], rightSelection[1:2]], newAreas)
        " echo "curPos: " . ListToString(curPos) . ", oldCurPos: " . ListToString(oldCurPos) . ", left: " . ListToString(leftSelection) . ", right: " . ListToString(rightSelection)
        if !areaSelection && (movLeft || movRight)
            "movement to the left
            call multiselect#appendPosition(curPos[1:2], newLocations)
        else
            "textobject or visual selection
            let areaSelection = 1
        endif
        if noMovement
            break
        endif
        if !multiselect#positionInArea(curPos[1:2], area)
            let newAreas = newAreas[0:-2]
            let newLocations = newLocations[0:-2]
            break
        endif
        if visual
            silent execute "norm " . movecommand
        endif
    endwhile "}}}
    if areaSelection
        "let length = len(newAreas)>2 ? -1 : 0
        return [areaSelection, newAreas]
    else
        "let length = len(newLocations)>2 ? -1 : 0
        return [areaSelection, newLocations] 
    endif
endfunction 
"}}}
function! multiselect#appendArea(area, areaList) "{{{
    if len(a:areaList) > 0 && a:areaList[-1] == a:area
        return -1
    endif
    call add(a:areaList, a:area)
endfunction
 "}}}
function! multiselect#returnRHS(command) "{{{

endfunction 

"}}}
function! multiselect#appendPosition(position, positionList) "{{{
    call add(a:positionList, a:position)
endfunction 

"}}}
function! multiselect#positionGreaterThan() "{{{
    curPos[1] > startingPosition[1] || curPos[1] == startingPosition[1] &&
endfunction
"}}}
function! multiselect#positionInArea(position, area) "{{{
    " echo a:position
    " echo a:area
    let biggerMin = multiselect#comparePosition(a:position, a:area[0])
    let smallerMax = multiselect#comparePosition(a:position, a:area[1]) == -1
    return (biggerMin && smallerMax)
endfunction
"}}}
function! multiselect#comparePosition(position1, position2) "{{{
    let [row1, col1] = a:position1
    let [row2, col2] = a:position2
    if row1 > row2 || (row1 == row2 && col1 > col2)
        return 1
    elseif row1 == row2 && col1 == col2
        return 0
    else
        return -1
    endif
endfunction
"}}}



" vim: set fdm=marker :"}}}
