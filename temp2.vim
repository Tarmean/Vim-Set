function! GetSubRanges(area, ranges)
    let i = 0
    let running = 1
    let inArea = []
    let result = []
    let area = a:area[0]
    while running && i < len(a:ranges)
        let bigger =  multiselect#comparePosition(area[0][1:2], a:ranges[i][0][1:2]) == -1
        let smaller =  multiselect#comparePosition(area[1][1:2], a:ranges[i][0][1:2]) == 1
        let running = bigger && smaller
        if running
            call add(inArea, a:ranges[i])
            let i += 1
        endif
    endwhile
    " echo inArea
    " call getchar()
    if len(inArea) > 0
        call add(result, [area[0], s:inc(inArea[0][0])])
        let j = 1
        while j < len(inArea)
            let result = result + s:betweenSlices(inArea[j - 1][1], inArea[j][0])
            let j += 1
        endwhile
        call add(result, [s:inc(inArea[-1][1]), s:dec(area[1])])
    endif
    return result
endfunction
let i = 0
    let running = 1
    let inArea = []
    let result = 
    let area = a:area
    while running && i < len(a:ranges)
        let bigger =  multiselect#comparePosition(area
, a:ranges
) == -1
        let smaller =  multiselect#comparePosition(area
, a:ranges
) == 1
        let running = bigger && smaller
        if running

            call add(inArea, a:ranges
)
            let i += 1
        endif
    endwhile
    " echo inArea
    " call getchar()
    if len(inArea) > 0

        call add(result, 
)
        let j = 1
        while j < len(inArea)

            let result = result + s:betweenSlices(inArea
, inArea
)
            let j += 1
        endwhile

        call add(result, 
)
    endif
    return result

function! s:inc(pos)
    let pos = [a:pos[0], a:pos[1], a:pos[2]+1, a:pos[3]]
    let linelength = col([pos[1], "$"])
    if pos[2] >= linelength
        let pos[1] +=1
        let pos[2] = 1
    endif
    return pos
endfunction
function! s:dec(pos)
    let pos = [a:pos[0], a:pos[1], a:pos[2]-1, a:pos[3]]
    if pos[2] <= 0
        let pos[1] -=1
        let pos[2] = 2147483647
    endif
    return pos
endfunction

function! s:betweenSlices(pos1, pos2)
    let area1 = s:inc(a:pos1)
    let area2 = s:dec(a:pos2)
    let linelength = col([area1[1], "$"])
    let delta = area2[1] - area1[1]
    let newSelection = []
    let end = []

    if delta > 0
        if area1[2] < linelength && multiselect#comparePosition(area1[1:2], [area1[1], linelength-1]) <= 0
            call add(newSelection, [copy(area1), [area1[0], area1[1], linelength - 1, area1[3]]])
        endif
        let area1[1] += 1
        let area1[2] = 1
    endif
    if  delta > 1

        if area2[2] > 0 && multiselect#comparePosition([area2[1], 1], area2[1:2]) <= 0
            "add to end of line
            let end =  [[area2[0], area2[1], 1, area2[3]],copy( area2)]
        endif
        let area2[1] -= 1
        let area2[2] = 2147483647
    endif
    if multiselect#comparePosition(area1[1:2], area2[1:2]) <= 0
        call add(newSelection, [copy(area1),area2])
    endif
    if len(end) > 0
        call add(newSelection, end)
    endif
    return newSelection
endfunction
