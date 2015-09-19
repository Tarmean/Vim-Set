"legacy{{{
let g:multi#prompt = ">"
function! NoArea() "{{{
    norm vii
    norm ygv
    norm! .

    echom multi#getAreaOrMotion(0)
    "return multi#getAreaOrMotion(1)
endfunction "}}}
onoremap <silent> im :call NoArea()<cr>
function! multi#getAreaOrMotion(...) "{{{
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
function! multi#getOmaps() "{{{
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
function! multi#getSelected() "{{{
    return [[getpos("'<")[1:2], getpos("'>")[1:2]]]
endfunction
 "}}}
function! multi#test() "{{{
    if(g:multi#multipending)
        call TestA("line")
    endif
endfunction
 "}}}
function! TestA(type) "{{{
    let g:multi#counter =0
    set operatorfunc=TestB
    norm! .
    set operatorfunc=TestA
    echo g:multi#counter
endfunction
function! TestB(type)
    let g:multi#counter += 1
endfunction "}}}"}}}

"Processing:{{{
function! multi#inittest() "{{{
    set nowrapscan
    let curpos = getpos(".")
    call multi#readAndProcess(v:operator)
    if g:yankresult != ""
        call setreg('"', g:yankresult, 'aV')
    else
        call setreg('"', g:multiresult, 'aV')
    endif
    call setpos(".", curpos)
    call setpos("'<", curpos)
    call setpos("'>", curpos)
    call setpos("'[", curpos)
    call setpos("']", curpos)
    set wrapscan
endfunction
onoremap . :call multi#inittest()<cr>
xnoremap . :call multi#inittest()<cr>
"}}}
function! multi#readAndProcess(endCom) "{{{
    if len(g:multi#matchidlist) != 0
        call multi#clearHighlights()
    endif
    let reading = 1
    let area = {"areas": [getpos(".")], "visual": 0}
    let startarea = {"areas": [getpos(".")], "visual": 0}
    let promptbase = a:endCom
    let motionstack = []
    let skipCon = 0
    while reading
        let  commandlist = multi#readOp(promptbase)
        if len(commandlist) == 2
            let [reading, command] = commandlist
            let alias = command
        else
            let [reading, command, alias] = commandlist
        endif
        if reading == -1
            call multi#clearHighlights()
            norm v
            return
        elseif command ==# "V"
            if area.visual
                let area = multi#visualToLines(area)
                call multi#applySelection(area)
                let reading = 1
            endif
        elseif command ==# "v"
            if area.visual
                let area = multi#visualToPoints(area)
                call multi#applySelection(area)
                let reading = 1
            endif
        elseif command ==# "."
            if area.visual
                let area = multi#visualToLines(area)
                let area = multi#visualToPoints(area)
                call multi#applySelection(area)
                let reading = 1
                let skipCon = 2
                let alias = " → "
            endif
        elseif command ==# "<BS>"
            if len(motionstack) == 1
                call multi#clearHighlights()
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
            let area = multi#chainMotions(motionlist, startarea)
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
            let area = multi#apply(command, area)
        endif
        call multi#applySelection(area)
    endwhile
    call multi#applyCommand(a:endCom, area)
endfunction


"}}}
function! multi#readOp(...) "{{{
    if a:0 == 0
        let base = ""
    else
        let base = a:1
    endif
    let [lhs, rhs] = multi#getOmaps()
    let reading = 1
    let i = 0
    let s = ""
    redraw | echo base . g:multi#prompt
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
                redraw | echo base . g:multi#prompt . s
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
                return [2, s."", s]
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
        redraw | echo base . g:multi#prompt . s
    endwhile
    return[0, s]
endfunction
"}}}
function! multi#applyCommand(command, areas) "{{{
    call multi#clearHighlights()
    let areas = reverse(a:areas.areas)
    if a:areas.visual
        norm! v
        let g:multiresult = ""
        let g:yankresult = ""
        let previousmultiReg = ""
        let previousYankReg = ""
        let multiRegModify = 0
        let yankRegModify = 0
        for area in areas
            call setreg('"', "")
            call setreg('0', "")
            call setpos("'<", area[0])
            call setpos("'>", area[1])
            execute "norm gv".a:command
            if getreg('"') != ""
                let multiRegModify = 1
                let previousmultiReg = getreg('"')
                let g:multiresult = previousmultiReg . "\n" . g:multiresult
            endif
            if getreg("0") != ""
                let yankRegModify = 1
                let previousYankReg = getreg("0")
                let g:yankresult = previousYankReg . "\n" . g:yankresult
            endif
        endfor
        call setreg('"', g:multiresult)
        call setreg('0', g:yankresult)
    else
        for area in areas
            call setpos(".", area)
            execute "norm ".a:command
        endfor
    endif
endfunction
"}}}
function! multi#chainMotions(commands, ...) "{{{
    if a:0 == 0
        let area = {area: [getpos("'<"), getpos("'>")], visual = 1}
    else
        let area = a:1
    endif
    let forcevisual = 0
    for command in a:commands
        if command ==# "V"
            if area.visual
                let area = multi#visualToLines(area)
            endif
        elseif command ==# "v"
            if area.visual
                let area = multi#visualToPoints(area)
            endif
        elseif command ==# "."
            if area.visual
                let area = multi#visualToLines(area)
                let area = multi#visualToPoints(area)
            endif
        else
            let area = multi#apply(command, area)
        endif
    endfor
    call multi#applySelection(area)
    return area
endfunction
"}}}
highlight multiArea ctermbg=gray guibg=#504640
highlight multiPosition ctermbg=gray guibg=#585559
let g:multi#matchidlist=[]
function! multi#apply(command, areas) "{{{
    let selection =  {"visual":0, "areas":[]}
    let areaSelection = 0
    if a:areas.visual
        for area in a:areas.areas
            let result = multi#applyArea(a:command, area)
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
            let result = multi#applyPosition(a:command, area)
            let areaSelection = areaSelection || result.visual
            if areaSelection
                if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                    call multi#appendArea(result.areas, selection.areas, area)
                endif
            else
                if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                    call multi#appendPosition(result.areas, selection.areas)
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
function! multi#applyPosition(command, location) "{{{
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
function! multi#applyArea(command, ...) "{{{
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
        let noMovement = multi#appendArea([leftSelection, rightSelection], newAreas, oldCurPos)
        " echo "curPos: " . ListToString(curPos) . ", oldCurPos: " . ListToString(oldCurPos) . ", left: " . ListToString(leftSelection) . ", right: " . ListToString(rightSelection)
        if !areaSelection && (movLeft || movRight)
            "movement to the left
            if multi#appendPosition(curPos, newLocations)
                break
            endif
        else
            "textobject or visual selection
            let areaSelection = 1
        endif
        if !multi#positionInArea(curPos, area)
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
function! multi#appendArea(area, areaList, oldCursor) "{{{
    if a:area[0] == a:area[1] && a:area[0] == a:oldCursor
        "call add(a:areaList, a:area)
        return -1
    endif
    if len(a:areaList) > 0 && a:areaList[-1] == a:area
        return -1
    endif
    if len(a:areaList) > 0 && multi#comparePosition(a:area[0][1:2], a:areaList[-1][0][1:2]) == -1
        return -1
    endif
    call add(a:areaList, a:area)
endfunction
 "}}}
function! multi#returnRHS(command) "{{{

endfunction

"}}}
function! multi#appendPosition(position, positionList) "{{{
    if len(a:positionList)>0 && !multi#comparePosition(a:position[1:2], a:positionList[-1][1:2])
        return 1
    endif
    call add(a:positionList, a:position)
endfunction

"}}}
function! multi#positionInArea(position, area) "{{{
    let biggerMin = multi#comparePosition(a:position[1:2], a:area[0][1:2]) == 1
    let smallerMax = multi#comparePosition(a:position[1:2], a:area[1][1:2]) == -1
    return (biggerMin && smallerMax)
endfunction
"}}}
function! multi#comparePosition(position1, position2) "{{{
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
function! multi#highlightArea(area) "{{{
     let [p1, p2] = a:area
     let delta = p2[1] - p1[1]
     if delta == 0
         return {"partials":[[p1[1], p1[2], p2[2]-p1[2]+1]], "full":[]}
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
function! multi#highlightPosition(area) "{{{
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
function! multi#clearHighlights() "{{{
    for id in g:multi#matchidlist
        call matchdelete(id)
    endfor
    let g:multi#matchidlist = []
endfunction
"}}}

function! multi#divide(list) "{{{
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
function! multi#visualToLines(areas) "{{{
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
function! multi#visualToPoints(areas) "{{{
    let pointlist = []
    for area in a:areas.areas
        call add(pointlist,area[0])
    endfor
    return {"areas": pointlist, "visual": 0}
endfunction
"}}}
function! multi#applyAreaSelection(areas) "{{{
    let partials = []
    let full = []
    for area in a:areas.areas
        let result = multi#highlightArea(area)
        let partials = partials + result.partials
        let full = full + result.full
    endfor
    let partials = multi#divide(partials)
    let fullid = []
    for lineblock in full
        call add(fullid, matchaddpos("multiArea",lineblock))
    endfor
    let partialid = []
    for partial in partials
        call add(fullid, matchaddpos("multiArea", partial))
    endfor
    let g:multi#matchidlist = fullid + partialid
endfunction
"}}}
function! multi#applyPositionSelection(areas) "{{{
    let idlist = []
    let segmentedlist = multi#highlightPosition(a:areas.areas)
    for pointlist in segmentedlist
        let id =  matchaddpos("multiPosition", pointlist)
        call add(idlist, id)
    endfor
    let g:multi#matchidlist = idlist
endfunction
"}}}
function! multi#applySelection(selection)
    call multi#clearHighlights()
    if a:selection.visual
        call multi#applyAreaSelection(a:selection)
    else
        call multi#applyPositionSelection(a:selection)
    endif
endfunction
"}}}
" vim: set fdm=marker :

