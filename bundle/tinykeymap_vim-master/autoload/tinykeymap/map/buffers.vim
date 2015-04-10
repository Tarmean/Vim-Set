" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-09-10.
" @Revision:    112

if !exists('g:tinykeymap#map#buffers#map')
    " Map leader for the "buffers" tinykeymap.
    let g:tinykeymap#map#buffers#map = g:tinykeymap#mapleader ."a"   "{{{2
endif


call tinykeymap#EnterMap("buffers", g:tinykeymap#map#buffers#map, {
            \ 'message': 'tinykeymap#buffers#List(g:tinykeymap#buffers#idx)',
            \ 'start': 'let g:tinykeymap#buffers#idx = 1 | let g:tinykeymap#buffers#filter = ""',
            \ })
call tinykeymap#Map('buffers', '<CR>', 'call tinykeymap#buffers#Buffer(<count>)', {'exit': 1})
call tinykeymap#Map('buffers', 'd', 'bd', {'exit': 1})
call tinykeymap#Map('buffers', 'b', 'buffer <count>')
call tinykeymap#Map('buffers', 's', 'sbuffer <count>')
call tinykeymap#Map('buffers', 'v', 'vert sbuffer <count>')
call tinykeymap#Map('buffers', 'j', 'bnext <count>')
call tinykeymap#Map('buffers', 'k', 'bprevious <count>')
call tinykeymap#Map('buffers', 'h', 'bfirst')
call tinykeymap#Map('buffers', 'l', 'blast')
call tinykeymap#Map('buffers', 'H', '<count>wincmd h', {'desc': 'Left window'})
call tinykeymap#Map('buffers', 'J', '<count>wincmd j', {'desc': 'Window below'})
call tinykeymap#Map('buffers', 'K', '<count>wincmd k', {'desc': 'Window above'})
call tinykeymap#Map('buffers', 'L', '<count>wincmd l', {'desc': 'Right window'})
call tinykeymap#Map('buffers', 'n', 'vnew')
call tinykeymap#Map('buffers', 'w', 'wincmd o', {'desc': 'Make the only window'})
call tinykeymap#Map('buffers', '<Space>', 'ls! | call tinykeymap#PressEnter()')
call tinykeymap#Map('buffers', 'C', 'bdelete! <count>')
call tinykeymap#Map('buffers', 'c', ':close')
call tinykeymap#Map('buffers', 'a', ':vert ball', {'desc': 'Open all buffers'})
 call tinykeymap#Map('buffers', 'q', ':tab sp', {'desc': 'Move to new Tab'})
call tinykeymap#Map('buffers', '<Left>', 'call tinykeymap#buffers#Shift(-<count1>)',
            \ {'desc': 'Rotate list to the right'})
call tinykeymap#Map('buffers', '<Right>', 'call tinykeymap#buffers#Shift(<count1>)',
            \ {'desc': 'Rotate list to the left'})
call tinykeymap#Map('buffers', '/', 'let g:tinykeymap#buffers#filter = input("Filter regexp: ")',
            \ {'desc': 'Prioritize buffers matching a regexp'})


