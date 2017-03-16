command! NivmInit exec NivmInit(expand("%:p:h"), expand("%:p:t"))
command! NivmHighlight exec NivmHighlight()
command! -nargs=1 NivmCommand exec NivmExecute(<args>, expand("%:p:t"), line("."), col("."))

" GruvBoxRed
" GruvboxAqua
" GruvboxBlue
" GruvboxGray
" GruvboxGreen
" GruvboxOrange
" GruvboxPurple
" GruvboxYellow
" GruvboxOrange
let g:dict = {
               \'skConst'     : 'GruvBoxAqua',
               \'skEnumField' : 'GruvboxAqua',
               \'skField'     : 'GruvBoxBlue',
               \'skIterator'  : 'GruvBoxGreen',
               \'skParam'     : 'GruvBoxBlue',
               \'skProc'      : 'GruvBoxPurple',
               \'skResult'    : 'GruvBoxBlue',
               \'skTemplate'  : 'GruvBoxAqua',
               \'skType'      : 'GruvBoxPurple',
               \'skVar'       : 'GruvboxBlue',
            \}
func! NivmHighlightApply(a)
    let g:highlight = a:a
    let highlights = split(a:a, "\r\n")[0:-2]
    for current in highlights
        let entries = split(current, "	")
        call matchaddpos(g:dict[entries[1]],  [[entries[2],(entries[3]  + 1), entries[4]]])
    endfor
endfunc




