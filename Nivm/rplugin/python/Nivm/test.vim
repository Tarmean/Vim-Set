let g:dict = {
               \'skConst'     : 'GruvboxGreen',
               \'skEnumField' : 'GruvboxAqua',
               \'skField'     : 'Gruvboxorange',
               \'skIterator'  : 'GruvboxBlue',
               \'skParam'     : 'GruvboxPurple',
               \'skProc'      : 'GruvboxYellow',
               \'skResult'    : 'GruvboxGray',
               \'skTemplate'  : 'GruvboxGreen',
               \'skType'      : 'GruvboxOrange',
               \'skVar'       : 'GruvboxAqua',
            \}
func! Test()
    for element in split(g:x, ",")
        let entries = split(element, "	")
        call matchaddpos(g:dict[entries[1]],  [[entries[2],(entries[3]  + 1), entries[4]]])
    endfor
endfunc
