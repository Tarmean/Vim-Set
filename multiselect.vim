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
    set nowrapscan
    let curpos = getpos(".")
    call multiselect#readAndProcess(v:operator)
    call setpos(".", curpos)
    call setpos("'<", curpos)
    call setpos("'>", curpos)
    call setpos("'[", curpos)
    call setpos("']", curpos)
    set wrapscan
endfunction
onoremap . :call multiselect#inittest()<cr>
xnoremap . :call multiselect#inittest()<cr>
"}}}
function! multiselect#readAndProcess(endCom) "{{{
    if len(g:multiselect#matchidlist) != 0
        call multiselect#clearHighlights()
    endif
    let reading = 1
    let area = {"areas": [getpos(".")], "visual": 0}
    let startarea = {"areas": [getpos(".")], "visual": 0}
    let promptbase = a:endCom
    let motionstack = []
    let skipCon = 0
    while reading
        let  commandlist = multiselect#readOp(promptbase)
        if len(commandlist) == 2
            let [reading, command] = commandlist
            let alias = command
        else
            let [reading, command, alias] = commandlist
        endif
        if reading == -1
            call multiselect#clearHighlights()
            norm v
            return
        elseif command ==# "V"
            if area.visual
                let area = multiselect#visualToLines(area) 
                call multiselect#applySelection(area)
                let reading = 1
            endif
        elseif command ==# "v"
            if area.visual
                let area = multiselect#visualToPoints(area) 
                call multiselect#applySelection(area)
                let reading = 1
            endif
        elseif command ==# "."
            if area.visual
                let area = multiselect#visualToLines(area) 
                let area = multiselect#visualToPoints(area) 
                call multiselect#applySelection(area)
                let reading = 1
                let skipCon = 2
                let alias = " → "
            endif
        elseif command ==# "<BS>"
            if len(motionstack) == 1
                call multiselect#clearHighlights()
            endif
            let motionlist = []
            let motionstack = motionstack[0:-2]
            let promptbase = a:endCom . " . "
            for motion in motionstack
                call add(motionlist, motion[0])
                if (motion[0] == ".")
                    let promptbase = promptbase . motion[1]
                else
                    let promptbase = promptbase . motion[1] . " . "
                endif
            endfor
            let area = multiselect#chainMotions(motionlist, startarea)
            continue
        endif
        if !skipCon
            let promptbase = promptbase  . " . " . alias
        else 
            let promptbase = promptbase  . alias
            let skipCon -= 1
        endif
        call add(motionstack, [command, alias])
        if reading == 2
            let area = multiselect#apply(command, area)
        endif
        call multiselect#applySelection(area)
    endwhile
    call multiselect#applyCommand(a:endCom, area)
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
        if -1 != index(["\<esc>", "\<c-c>", "\<del>"], c)
            return [-1, ""]
        endif
        if -1 != index(["\<backspace>"], c)
            if i>0
                let s = s[0:-2]
                let i -= 1
                redraw | echo base . g:multiselect#prompt . s
            else
                return [1, "<BS>"]
            endif
            continue
        endif
        if (c ==# "f" || c == "t") && i == 0
            let d = sneak#util#getchar()
            return [2, "".c . d . "" , c.d]
        endif
        if c ==# "\<CR>"
            if match(s, "^\/.\*$") == 0
                return [2, s."", s]
            endif
            if i > 0 "special case: accept the current input (#15)
                return [2, s]
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
                return [2, s]
            endif
        endfor
        redraw | echo base . g:multiselect#prompt . s
    endwhile
    return[0, s]
endfunction
"}}}
function! multiselect#applyCommand(command, areas) "{{{
    call multiselect#clearHighlights()
    let areas = reverse(a:areas.areas)
    if a:areas.visual
        norm! v
        let result = ""
        let previousReg = @"
        for area in areas
            call setpos("'<", area[0])
            call setpos("'>", area[1])
            execute "norm gv".a:command
            if @" != previousReg
                let previousReg = @""
                let result = previousReg . "\n" . result
            endif
        endfor
        let @" = result
    else
        for area in areas
            call setpos(".", area)
            execute "norm ".a:command
        endfor
    endif
endfunction
"}}}
function! multiselect#chainMotions(commands, ...) "{{{
    if a:0 == 0
        let area = {area: [getpos("'<"), getpos("'>")], visual = 1}
    else
        let area = a:1
    endif
    let forcevisual = 0
    for command in a:commands
        if command ==# "V"
            if area.visual
                let area = multiselect#visualToLines(area) 
            endif
        elseif command ==# "v"
            if area.visual
                let area = multiselect#visualToPoints(area) 
            endif
        elseif command ==# "."
            if area.visual
                let area = multiselect#visualToLines(area) 
                let area = multiselect#visualToPoints(area) 
            endif
        else
            let area = multiselect#apply(command, area)
        endif
    endfor
    call multiselect#applySelection(area)
    return area
endfunction
"}}}
highlight MultiselectArea ctermbg=gray guibg=#504640 
highlight MultiselectPosition ctermbg=gray guibg=#585559
let g:multiselect#matchidlist=[]
function! multiselect#apply(command, areas) "{{{
    let selection =  {"visual":0, "areas":[]}
    let areaSelection = 0
    if a:areas.visual
        for area in a:areas.areas
            let result = multiselect#applyArea(a:command, area)
            let areaSelection = areaSelection || result.visual
            if areaSelection
                let selection.areas = selection.areas + result.areas
            else
                let selection.areas = selection.areas + result.areas
            endif
            " echo areaSelection ? newAreas : newLocations
        endfor
    else
        for area in a:areas.areas
            let result = multiselect#applyPosition(a:command, area)
            let areaSelection = areaSelection || result.visual
            if areaSelection
                if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                    call multiselect#appendArea(result.areas, selection.areas, area)
                endif
            else
                if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                    call multiselect#appendPosition(result.areas, selection.areas)
                endif
            endif
            " echo result
        endfor
    endif
    if areaSelection
        return {"visual":1, "areas":selection.areas}
    else
        return {"visual":0, "areas":selection.areas}
    endif
endfunction

 "}}}
function! multiselect#applyPosition(command, location) "{{{
    call setpos(".", a:location)
    silent execute "norm v" . a:command . ""
    let curPos = getpos(".")
    let leftSelection =  getpos("'<")
    let rightSelection =  getpos("'>")
    let movLeft = leftSelection == curPos && rightSelection == a:location
    let movRight = leftSelection == a:location && rightSelection == curPos
    let shittyWordObjectHeuristic = (a:command[0] == 'a'|| a:command[0] == 'i')
    if (movLeft || movRight) && !shittyWordObjectHeuristic && a:location != getpos(".")
        "movement to the left
        return {"visual":0, "areas":curPos}
    else
        "textobject or visual selection
        return{"visual":1, "areas":[leftSelection, rightSelection]}
    endif
    " return {"visual":0, "areas":[]}
endfunction
"}}}
function! multiselect#applyArea(command, ...) "{{{
    if a:0 == 0
        let area = [getpos("'<"), getpos("'>")]
    elseif a:0 == 1
        let visual = 0
        let area = a:1
    else
        let visual = 1
        let area = a:1
        let movecommand =""
    endif
    " echo area

    let shittyWordObjectHeuristic = (a:command[0] == 'a'|| a:command[0] == 'i')
    let areaSelection = visual || shittyWordObjectHeuristic
    let inside = 1
    call setpos(".", area[0])
    norm v
    let curPos = getpos(".")
    let startingPosition = getcurpos()
    let newLocations = []
    let newAreas = []
    while inside "{{{
        let oldCurPos = curPos
        silent! execute "norm v" . a:command . ""
        let curPos = getpos(".")
        let leftSelection =  getpos("'<")
        let rightSelection =  getpos("'>")
        let movLeft = leftSelection == curPos && rightSelection == oldCurPos
        let movRight = leftSelection == oldCurPos && rightSelection == curPos
        let noMovement = multiselect#appendArea([leftSelection, rightSelection], newAreas, oldCurPos)
        " echo "curPos: " . ListToString(curPos) . ", oldCurPos: " . ListToString(oldCurPos) . ", left: " . ListToString(leftSelection) . ", right: " . ListToString(rightSelection)
        if !areaSelection && (movLeft || movRight)
            "movement to the left
            if multiselect#appendPosition(curPos, newLocations)
                break
            endif
        else
            "textobject or visual selection
            let areaSelection = 1
        endif
        if !multiselect#positionInArea(curPos, area)
            let newAreas = newAreas[0:-2]
            let newLocations = newLocations[0:-2]
            break
        endif
        if visual
            silent execute "norm " . movecommand
        endif
        if noMovement
            break
        endif
    endwhile "}}}
    noh
    norm! 
    if areaSelection
        "let length = len(newAreas)>2 ? -1 : 0
        return {"visual":areaSelection, "areas":newAreas}
    else
        "let length = len(newLocations)>2 ? -1 : 0
        return {"visual":areaSelection, "areas":newLocations} 
    endif
endfunction 
"}}}
function! multiselect#appendArea(area, areaList, oldCursor) "{{{
    if a:area[0] == a:area[1] && a:area[0] == a:oldCursor
        "call add(a:areaList, a:area)
        return -1
    endif
    if len(a:areaList) > 0 && a:areaList[-1] == a:area
        return -1
    endif
    if len(a:areaList) > 0 && multiselect#comparePosition(a:area[0][1:2], a:areaList[-1][0][1:2]) == -1
        return -1
    endif
    call add(a:areaList, a:area)
endfunction
 "}}}
function! multiselect#returnRHS(command) "{{{

endfunction 

"}}}
function! multiselect#appendPosition(position, positionList) "{{{
    if len(a:positionList)>0 && !multiselect#comparePosition(a:position[1:2], a:positionList[-1][1:2])
        return 1
    endif
    call add(a:positionList, a:position)
endfunction 

"}}}
function! multiselect#positionInArea(position, area) "{{{
    let biggerMin = multiselect#comparePosition(a:position[1:2], a:area[0][1:2]) == 1
    let smallerMax = multiselect#comparePosition(a:position[1:2], a:area[1][1:2]) == -1
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
function! multiselect#highlightArea(area) "{{{
     let [p1, p2] = a:area
     let delta = p2[1] - p1[1]
     if delta == 0
         return {"partials":[[p1[1], p1[2], p2[2]-p1[2]]], "full":[]}
     endif
     let partials = [[p1[1], p1[2], col([p1[1], "$"])-p1[2]]]
     call add(partials, [p2[1], 0, p2[2]])
     let full = []
     let fulllist = []
     let divider = 0
     while delta > 1
        let delta = delta - 1
        call add(full, [p1[1]+delta])
        let divider += 1
        if divider > 7
            let divider = 0
            call add(fulllist,full)
            let full = []
        endif
     endwhile
     call  add(fulllist,full)
     return {"partials":partials, "full":fulllist}
 endfunction
 "}}}
function! multiselect#highlightPosition(area) "{{{
    let points = []
    let segmentedlist = []
    let divider = 0
    for position in a:area
        let divider += 1
        if divider > 7
            let divider = 0
            call add(segmentedlist,points)
            let points = []
        endif
        call add(points, position[1:2])
    endfor
    call add(segmentedlist,points)
    return segmentedlist
endfunction
function! multiselect#clearHighlights() "{{{
    for id in g:multiselect#matchidlist
        call matchdelete(id)
    endfor
    let g:multiselect#matchidlist = []
endfunction
"}}}

" vim: set fdm=marker :"}}}
function! multiselect#divide(list) "{{{
    let divider = 0
    let dividedlist = []
    let sublist = []
    for entry in a:list
        let divider += 1
        call add(sublist, entry)
        if divider > 7
            call add(dividedlist, sublist)
            let divider = 0
            let sublist = []
        endif
    endfor
    call add(dividedlist, sublist)
    return dividedlist
endfunction
"}}}
function! multiselect#visualToLines(areas) "{{{
    let linelist = []
    for area in a:areas.areas
        let left = area[0]
        let right = area[1]
        let delta = right[1] - left[1]
        if (left[1] == right[1])
            call add(linelist, s:toLineWith(left, 0))
        else
            let return = s:toLineWith(left, 0)
            call add(linelist, return)
            let i = 1
            while delta > i
                let result = s:toLineWith(left, i)
                call add(linelist,result)
                let i += 1
            endwhile
            let result = s:toLineWith(left, i)
            call add(linelist,result)
        endif
    endfor
    return {"areas":linelist, "visual":1}
endfunction
"}}}
function! s:toLineWith(area, offset) "{{{
    return [[a:area[0],a:area[1]+a:offset, 1, a:area[3]], [a:area[0],a:area[1]+a:offset, 2147483647, a:area[3]]]
endfunction
"}}}
function! multiselect#visualToPoints(areas) "{{{
    let pointlist = []
    for area in a:areas.areas
        call add(pointlist,area[0])
    endfor
    return {"areas": pointlist, "visual": 0}
endfunction
"}}}
function! multiselect#applyAreaSelection(areas) "{{{
    let partials = []
    let full = []
    for area in a:areas.areas
        let result = multiselect#highlightArea(area)
        let partials = partials + result.partials
        let full = full + result.full
    endfor
    let partials = multiselect#divide(partials)
    let fullid = []
    for lineblock in full
        call add(fullid, matchaddpos("MultiselectArea",lineblock))
    endfor
    let partialid = []
    for partial in partials
        call add(fullid, matchaddpos("MultiselectArea", partial))
    endfor
    let g:multiselect#matchidlist = fullid + partialid
endfunction
"}}}
function! multiselect#applyPositionSelection(areas) "{{{
    let idlist = []
    let segmentedlist = multiselect#highlightPosition(a:areas.areas)
    for pointlist in segmentedlist
        let id =  matchaddpos("MultiselectPosition", pointlist)
        call add(idlist, id)
    endfor
    let g:multiselect#matchidlist = idlist
endfunction
"}}}
function! multiselect#applySelection(selection)
    call multiselect#clearHighlights()
    if a:selection.visual
        call multiselect#applyAreaSelection(a:selection)
    else
        call multiselect#applyPositionSelection(a:selection)
    endif
endfunction
