"legacy{{{
let g:multiselect#prompt = ">"
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
    return lhsList
endfunction
 "}}}
function! multiselect#getSelected() "{{{
    return ListToString(getpos("'<")[1:2])." ".ListToString( getpos("'>")[1:2])
endfunction
function! Tester(type)
    let g:cannary= multiselect#comparePosition(getpos("'[")[1:2], getpos("']")[1:2])!=-1
endfunction
map <Plug>Cannary :let g:cannary=1<cr>:set opfunc=Tester<cr>g@
function! TestCarrier(motion)
    execute "norm \<Plug>Cannary" . "ib"
    echo g:cannary
    if !g:cannary
        echo ListToString(getpos("'[")) . " " . ListToString(getpos("']"))
    else
        echo "NOPE"
    endif 
endfunction
 "}}}
"}}}
"Processing:{{{
"{{{
let g:yankresult = ""
let g:tempresult = ""
vnoremap  <silent><Plug>dummyop :<c-u>let g:multiselect#cannary=1<cr><esc>
vnoremap <space>n <Plug>dummyop
function! Test(motion)
    let g:multiselect#cannary = 0
    execute "normal v" . a:motion . "\<Plug>dummyop"
    echo g:multiselect#cannary
endfunction
"}}}
function! multiselect#inittest() "{{{
    let command = v:operator
    set nowrapscan
    set nocursorline

    let curpos = getpos(".")
    let area = {"areas": [getpos(".")], "visual": 0}
    call multiselect#applySelection(area)
    let result = multiselect#readAndProcess(command, area)
    if type(result) == type({})
        call multiselect#applyCommand(command, result)
        " call multiselect#chainCommands(result)
    endif
    if g:yankresult != ""
        call setreg('"', g:yankresult, 'aV')
    else
        call setreg('"', g:tempresult, 'aV')
    endif
    call setpos(".", curpos)
    call setpos("'<", curpos)
    call setpos("'>", curpos)
    call setpos("'[", curpos)
    call setpos("']", curpos)
    set wrapscan
    set cursorline
    let curpos = getpos(".")
endfunction
"}}}
function! multiselect#startVisual() "{{{
    set nowrapscan
    let curPos = getpos(".")
    let leftSel = getpos("'<")
    let rightSel = getpos("'>")
    if leftSel != rightSel
        let area = {"areas": [[leftSel,rightSel]], "visual": 1}
    else
        let area = {"areas": [curPos], "visual": 0}
    endif
    call multiselect#applySelection(area)
    let areas = multiselect#readAndProcess(v:operator, area, [])
    if type(areas) == type({})
        " call multiselect#applyCommand("@q", area)
        call multiselect#chainCommands(areas)
    endif
    if g:yankresult != ""
        call setreg('"', g:yankresult, 'aV')
    else
        call setreg('"', g:tempresult, 'aV')
    endif
    call setpos(".", curPos)
    call setpos("'<", curPos)
    call setpos("'>", curPos)
    call setpos("'[", curPos)
    call setpos("']", curPos)
    set wrapscan
endfunction
"}}}
"mappings{{{
onoremap <silent>. :call multiselect#inittest()<cr>
xnoremap <silent>. :<c-u>call multiselect#startVisual()<cr>
"}}}
function! multiselect#readAndProcess(endCom, ...) "{{{
    let reading = 1
    if a:0 == 2
        let area = a:1
        let startarea = area
        let motionstack = a:2
    else
        let area = {"areas": [getpos(".")], "visual": 0}
        let startarea = area
        let motionstack = []
    endif
    let promptbase = a:endCom
    let forceVisual = 0
    let g:stack = {"states":[{"command":{"alias":a:endCom}, "areas": area}], "pushState": function("s:pushState")}
    while reading
        let result = ReadOp(g:defaultCommands, g:stack)
        if result.state == -1
            echo ""
            redraw!
            return {"areas":[], "visual":0}
        elseif result.state == 0
            let area = g:stack.states[-1].areas
            call multiselect#applySelection(area)
            redraw!
            continue
        elseif result.state == 2
            echo ""
            redraw!
            return area
        endif
        let command = result.command
        let area = multiselect#apply(command, area, forceVisual)
        call g:stack.pushState(result, area)
        call multiselect#applySelection(area)
        redraw!
        " let reading = 2 "result.state"{{{
        " let alias = alias . result.alias
        " call s:updatePrompt(alias, "")
        " if reading == -1
        "     call multiselect#clearHighlights()
        "     norm v
        "     return
        " elseif command ==# "V"
        "     if area.visual
        "         let area = multiselect#visualToLines(area)
        "         call multiselect#applySelection(area)
        "         let reading = 1
        "     endif
        " elseif command ==# "v"
        "     if area.visual
        "         let area = multiselect#visualToPoints(area.areas)
        "         call multiselect#applySelection(area)
        "         let reading = 1
        "     else
        "         let forceVisual = 1
        "         let reading = 1
        "         let promptbase = promptbase  . " . v"
        "         let skipCon = 1
        "         continue
        "     endif
        " elseif command ==# "."
        "     if area.visual
        "         let area = multiselect#visualToLines(area)
        "         let area = multiselect#visualToPoints(area.areas)
        "         call multiselect#applySelection(area)
        "         let reading = 1
        "         let skipCon = 2
        "         let alias = " → "
        "     endif
        " elseif command ==# "<BS>"
        "     if len(motionstack) == 1
        "         call multiselect#clearHighlights()
        "     endif
        "     let motionlist = []
        "     let motionstack = motionstack[0:-2]
        "     let promptbase = a:endCom . " . "
        "     for motion in motionstack
        "         call add(motionlist, motion[0])
        "         if (motion[0] == ".")
        "             let promptbase = promptbase . motion[1]
        "         else
        "             let promptbase = promptbase . motion[1] . " . "
        "         endif
        "     endfor
        "     let area = multiselect#chainMotions(motionlist, startarea)
        "     continue
        " endif
        " call add(motionstack, [command, alias])
        " let oldVisual = area.visual
        " if reading == 2
        " endif
        " if oldVisual == 0 && area.visual == 0
        "     let skipCon = skipCon ? skipCon : 1
        " endif
        " if !skipCon
        "     let promptbase = promptbase  . " . " . alias
        " else
        "     let promptbase = promptbase  . alias
        "     let skipCon -= 1
        " endif
        " if area.visual && forceVisual
        "     let forceVisual = 0
        " endif"}}}
    endwhile
endfunction


"}}} 
""Predefined Motions:{{{
let g:predefined = ["w", "W", "b", "B", "e", "ge", "E", "gE", "iw", "iW", "aw", "aW", "v", "V", "is", "as", 'i"', 'a"', "ib", "ab", "iB", "aB", "i)", "a)", "i}", "a}", "i]", "a]" ]
""}}}
"StateStack {{{
function! s:pushState(command, areas) dict
    call add(self.states, {"command": a:command, "areas": a:areas})
endfunction
let stack = {"states":[], "pushState": function("s:pushState")}
"}}}
"CommandStructPrimitives"{{{
function! multiselect#initCommandStruct() "{{{
    return {"command":"",
           \"alias":"",
           \"state":1
           \}
endfunction
"}}}
function! s:updatePrompt(command, base) "{{{
    redraw | echo a:base . g:multiselect#prompt . a:command
endfunction
"}}}
function! s:abort(...) "{{{
    let a:1.state = -1
endfunction
"}}}
function! s:backspace(...) "{{{
    let result = a:1
    let stack = a:2
    let entry = a:3
    if len(result.command) >= 4
        let result.command = result.command[0:-5]
        let result.alias = result.alias[0:-5]
        return 1
    elseif has_key(result,"count")
        if result.count > 1
            let result.count = max([result.count/10, 1])
            let result.command = result.command[0:-5]
            let result.alias = result.alias[0:-5]
            return 1
        else
            let result.command = ""
            let result.alias = result.alias[0:-5]
            call remove(result, "count")
            return 1
        endif
    else
        if len(stack.states) == 1
            let result.command = ""
            let result.alias = result.alias[0:-5]
            let result.state = -1
            return
        else
            let result.state = 0
            call remove(stack.states, -1)
            return -1
    endif
endfunction
"}}}
function! s:count(...) "{{{
    let entry = a:1
    if !has_key(entry, "count")
        let entry.count = entry.command[0] - '0'
    else
        let entry.count = entry.count * 10
        let entry.count += entry.command[0] - '0'
    endif
    let entry.command = ""
    let entry.alias = entry.count
    return 1
endfunction
"}}}
function! s:carriagereturn(...) "{{{
    let entry = a:1
    let entry.command = entry.command[0:-2]
    let entry.alias = entry.alias[0:-2]
    if len(entry.command) == 0
        let entry.state = 2
    endif
endfunction
"}}}
function! s:aliascleaner(...) "{{{
    let a:3.alias =  a:1.alias[0:-2]
endfunction
"}}}
"}}}
"defaultCommand {{{
let g:defaultCommands = 
    \{
        \"regex": [
                \{
                    \"match":".*\<esc>\\|.*\<c-c>",
                    \"postMatch":"s:abort",
                    \"command":"",
                    \"state":-1
                \},
                \{
                    \"match":".*\<BS>",
                    \"postMatch":"s:backspace",
                \},
                \{
                    \"match":"^[0-9]$",
                    \"postMatch":"s:count",
                \},
                \{
                    \"match":"^/.*",
                    \"postMatch":"s:aliascleaner"
                \},
                \{
                    \"match":".*$",
                    \"postMatch":"s:carriagereturn",
                \},
                \{
                    \"match":"^f.$",
                \},
            \],
        \"motion": multiselect#getOmaps()
    \}
"}}}
function! ReadOp(commandList, stack) "{{{
    let commandStruct = multiselect#initCommandStruct()
    let alias =  a:stack.states[-1].command.alias
    call s:updatePrompt("", alias)
    " -1 -> failure
    " 1 -> success
    " 2 -> finished
    while 1
        let finish = -1
        let c = sneak#util#getchar()

        let commandStruct.command = commandStruct.command . c
        let commandStruct.alias = commandStruct.alias . c

        for entry in a:commandList.regex
            if match(commandStruct.command, entry.match) == 0
                let finish = 1
                if has_key(entry, "command")
                    let commandStruct.command = entry.command
                endif
                if has_key(entry, "postMatch")
                    let finish =  call(entry.postMatch, [commandStruct, a:stack, entry])
                endif
                if has_key(entry, "pre")
                    let commandStruct.pre = entry.pre
                endif
                if finish == 0
                    if has_key(entry,"alias")
                        let commandStruct.alias = alias . "." . entry.alias
                    else
                        let commandStruct.alias = alias . "." . commandStruct.command
                    endif
                    if !has_key(commandStruct, "count")
                        let commandStruct.count = 1
                    endif
                    return commandStruct
                elseif finish < 0
                    return commandStruct
                endif
            endif
        endfor

        if finish == -1
            for motion in a:commandList.motion
                if motion ==# commandStruct.command
                    let commandStruct.alias = alias . "." . motion
                    return commandStruct
                endif
            endfor
        endif

        call s:updatePrompt(commandStruct.alias, alias)
    endwhile
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
        if (c == "f" || c == "t") && i == 0
            let d = sneak#util#getchar()
            if d == "/"
                let d = "\\/"
            endif
            return [2, "/\\V" . d . "" , c.d]
        endif
        if c ==# "\<CR>"
            if match(s, "^\/.\*$") == 0
                return [2, s."", s]
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
        for mapping in g:predefined
            if result ==# mapping
                return [2, s]
            endif
        endfor

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
    let selection = {"positions":[], "areas":[], "visual":0}
    let areaSelection=0
    if a:areas.visual
        let g:tempresult = ""
        let g:yankresult = ""
        let previousTempReg = ""
        let previousYankReg = ""
        let tempRegModify = 0
        let yankRegModify = 0
        for area in areas
            call setreg('"', "")
            call setreg('0', "")
            call setpos("'m",area[1])
            let result = multiselect#applyPosition( "`m", a:command, area[0], 0, 1)
            let areaSelection = areaSelection || result.visual
            if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                call multiselect#appendArea(result.areas, selection.areas, area)
            endif
            if !areaSelection
                if(len(selection.positions) == 0 || selection.positions[-1] != result.position)
                    call multiselect#appendPosition(result.position, selection.positions)
                endif
            endif
            if getreg('"') != ""
                let tempRegModify = 1
                let previousTempReg = getreg('"')
                let g:tempresult = previousTempReg . "\n" . g:tempresult
            endif
            if getreg("0") != ""
                let yankRegModify = 1
                let previousYankReg = getreg("0")
                let g:yankresult = previousYankReg . "\n" . g:yankresult
            endif
        endfor
        call setreg('"', g:tempresult)
        call setreg('0', g:yankresult)
        if areaSelection
            return {"areas":reverse(selection.areas),"visual":1}
        else
            let points = (selection.positions)
            " call getchar()
            return {"areas":points,"visual":0}
        endif
    else
        for area in areas
            call setreg('"', "")
            call setreg('0', "")
            let result = multiselect#applyPosition("v",a:command, area, 0, 1)
            let areaSelection = areaSelection || result.visual
            if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                call multiselect#appendArea(result.areas, selection.areas, area)
            endif
            if !areaSelection
                if(len(selection.positions) == 0 || selection.positions[-1] != result.position)
                    call multiselect#appendPosition(result.position, selection.positions)
                endif
            endif
        endfor
        if areaSelection
            return {"areas":reverse(selection.areas),"visual":1}
        else
            return {"areas":reverse(selection.positions),"visual":0}
        endif
    endif

endfunction
"}}}
function! multiselect#chainCommands(areas) "{{{
    let running = 1
    let areas = a:areas
    while running
        let command = input(g:multiselect#prompt)
        let g:command = command
        if command == ""
            let running = 0
        endif
        let areas = multiselect#applyCommand(command, areas)
        echo areas
        let g:areas = areas
        call multiselect#applySelection(areas)
        redraw
    endwhile
    call multiselect#clearHighlights()
endfunction
"}}}
function! multiselect#chainMotions(commands, ...) "{{{
    if a:0 == 0
        let area = {area: [getpos("'<"), getpos("'>")], visual = 1}
    else
        let area = a:1
    endif
    let forceVisual = 0
    for command in a:commands
        if command ==# "V"
            if area.visual
                let area = multiselect#visualToLines(area)
            endif
        elseif command ==# "v"
            if area.visual
                let area = multiselect#visualToPoints(area.areas)
            else 
                let forceVisual = 1
            endif
        elseif command ==# "."
            if area.visual
                let area = multiselect#visualToLines(area)
                let area = multiselect#visualToPoints(area.areas)
            endif
        else
            let area = multiselect#apply(command, area, forceVisual)
            if forceVisual && area.visual
                let forceVisual = 0
            endif
        endif
    endfor
    call multiselect#applySelection(area)
    return area
endfunction
"}}}
highlight MultiselectArea ctermbg=gray guibg=#504640 
highlight MultiselectPosition ctermbg=gray guibg=#585559
let g:multiselect#matchidlist=[]
function! multiselect#apply(command, areas, visualMode) "{{{
    let selection =  {"visual":0, "areas":[], "positions":[]}
    let areaSelection = 0
    if a:areas.visual
        for area in a:areas.areas
            let result = multiselect#applyArea(a:command, area)
            if result.visual != -1
                let areaSelection = areaSelection || result.visual
                if areaSelection
                    let selection.areas = selection.areas + result.areas
                else
                    let selection.positions = selection.positions + result.areas
                endif
            endif
            " echo areaSelection ? newAreas : newLocations
        endfor
    else
        for area in a:areas.areas
            let oldPos = getpos(".")
            let result = multiselect#applyPosition(a:command, "\<Plug>dummyop", area, a:visualMode)
            if result.visual != -1
                let areaSelection = areaSelection || result.visual
                if(len(selection.areas) == 0 || selection.areas[-1] != result.areas)
                    call multiselect#appendArea(result.areas, selection.areas, area)
                endif
                if !areaSelection
                    if(len(selection.areas) == 0 || selection.areas[-1] != result.position)
                        call multiselect#appendPosition(result.position, selection.positions)
                    endif
                endif
            endif
            " echo result
        endfor
    endif
    if areaSelection
        return {"visual":1, "areas":selection.areas}
    else
        return {"visual":0, "areas":selection.positions}
    endif
endfunction

"}}}
function! multiselect#applyPosition(command, context, location, forceVisual, ...) "{{{
    call setpos(".", a:location)

    if a:0 == 0
        let g:multiselect#cannary = 0
        silent! execute "norm v" .  a:command . a:context
    else
        execute "norm v" .  a:command . a:context
        let g:multiselect#cannary = 1
    endif
    if !g:multiselect#cannary
        return{"visual":-1, "areas":[], "position": []}
    endif
    let forward = getpos("'<")
    let backward = getpos("'>")
    let forceMotion = 0
    let curPos = getpos(".")
    let movRight = forward == a:location
    let movLeft = backward == a:location
    let shittyWordObjectHeuristic = (a:command[0] == 'a'|| a:command[0] == 'i')
    let textobjectCheck = !(movRight||movLeft) || shittyWordObjectHeuristic
    if !(textobjectCheck || forceMotion) && !a:forceVisual
        let visual = 0
    else
        let visual = 1
    endif
    " if movRight
    " else
    "     let newPos = forward
    " endif
    call setpos(".", backward)
    let result = {"visual":visual, "areas":[forward, backward], "position": a:0>0? curPos : backward}
    return result
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
    let curPos = getpos(".")
    let startingPosition = getcurpos()
    let newLocations = []
    let newAreas = []
    while inside "{{{
        let oldCurPos =  getpos(".")
        let return = multiselect#applyPosition(a:command, "\<Plug>dummyop", oldCurPos, 0)
        if return.visual == -1
            if oldCurPos == getpos(".")
                break
            else
                continue
            endif
        endif
        let noMovement = multiselect#appendArea([return.areas[0], return.areas[1]], newAreas, oldCurPos)
        " echo "curPos: " . ListToString(curPos) . ", oldCurPos: " . ListToString(oldCurPos) . ", left: " . ListToString(leftSelection) . ", right: " . ListToString(rightSelection)
        if !areaSelection && !visual
            "movement to the left
            if multiselect#appendPosition(return.position, newLocations)
                break
            endif
        else
            "textobject or visual selection
            let areaSelection = 1
        endif
        if !multiselect#positionInArea(return.position, area)
            norm! 
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
"}}}
function! multiselect#clearHighlights() "{{{
    for id in g:multiselect#matchidlist
        call matchdelete(id)
    endfor
    let g:multiselect#matchidlist = []
endfunction
"}}}
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
    for area in a:areas
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
function! multiselect#applySelection(selection) "{{{
    call multiselect#clearHighlights()
    if a:selection.visual
        call multiselect#applyAreaSelection(a:selection)
    else
        call multiselect#applyPositionSelection(a:selection)
    endif
endfunction
"}}}
"}}}
" vim: set fdm=marker :
