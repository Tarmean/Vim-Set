" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    31


if !exists('g:tinykeymap#map#tabs#map')
    " Map leader for the "tabs" tinykeymap.
    let g:tinykeymap#map#tabs#map = g:tinykeymap#mapleader ."t" "{{{2
endif

augroup TinyKeyMapTabs
    au!
    au TabLeave * let g:tkm_previous_tab = tabpagenr()
augroup END


" Based on Andy Wokulas's tabs mode for tinymode.
call tinykeymap#EnterMap('tabs', g:tinykeymap#map#tabs#map, {'name': 'tabs mode'})
call tinykeymap#Map('tabs', 'n', 'tabnew') 
call tinykeymap#Map('tabs', 't', ':TabNext <count>') 
call tinykeymap#Map('tabs', 'T', ':tabp <count>') 
call tinykeymap#Map('tabs', "l", ':TabNext <count>')
call tinykeymap#Map('tabs', "h", ':tabp <count>')
call tinykeymap#Map('tabs', "j", 'exec "tabmove" (max([1, tabpagenr() - 1]) - 1)')
call tinykeymap#Map('tabs', "k", 'exec "tabmove" (max([0, tabpagenr() - 1]) + 1)')
call tinykeymap#Map("tabs", "^", "tabfirst")
call tinykeymap#Map("tabs", "$", "tablast")
call tinykeymap#Map("tabs", "<Home>", "tabfirst")
call tinykeymap#Map("tabs", "<End>", "tablast")
call tinykeymap#Map("tabs", "c", "tabclose")
call tinykeymap#Map("tabs", "<Del>", "tabclose")
call tinykeymap#Map("tabs", "<BS>", "tabclose")
call tinykeymap#Map("tabs", "p", "call tinykeymap#tabs#Previous()", {'desc': 'Previous tab'})
call tinykeymap#Map('tabs', 'H', '<count>wincmd h', {'desc': 'Left window'})
call tinykeymap#Map('tabs', 'J', '<count>wincmd j', {'desc': 'Window below'})
call tinykeymap#Map('tabs', 'K', '<count>wincmd k', {'desc': 'Window above'})
call tinykeymap#Map('tabs', 'L', '<count>wincmd l', {'desc': 'Right window'})
call tinykeymap#Map('tabs', "u", 'call Clone_rel_tab_backwards(1, <count>)', {'desc': 'Move window to left tab'})
call tinykeymap#Map('tabs', "i", 'call Clone_rel_tab_forwards(1, <count>)', {'desc': 'Move window to right tab'})
call tinykeymap#Map('tabs', "U", 'call Clone_rel_tab_backwards(0, <count>)', {'desc': 'Open window to left tab'})
call tinykeymap#Map('tabs', "I", 'call Clone_rel_tab_forwards(0, <count>)', {'desc': 'Open window to right tab'})
call tinykeymap#Map('tabs', 'w', ':CloneToTab 1 <count>', {'desc': 'Clone to tab'})
call tinykeymap#Map('tabs', 'W', ':CloneToTab 0 <count>', {'desc': 'Copy to tab'})

if exists('g:loaded_tlib') && g:loaded_tlib > 0
    call tinykeymap#Map("tabs", "s", "tabnew +TScratch!", {'desc': 'Scratch tab', 'exit': 1})
endif

