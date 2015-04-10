" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    31


if !exists('g:tinykeymap#map#tabs#map')
    " Map leader for the "tabs" tinykeymap.
    let g:tinykeymap#map#tabs#map = "t"   "{{{2
endif

augroup TinyKeyMapTabs
    au!
    au TabLeave * let g:tkm_previous_tab = tabpagenr()
augroup END


" Based on Andy Wokulas's tabs mode for tinymode.
call tinykeymap#EnterMap('tabs', g:tinykeymap#map#tabs#map, {'name': 'tabs mode'})
call tinykeymap#Map('tabs', 'n', 'tabnew') 
call tinykeymap#Map('tabs', 't', 'norm! gt') 
call tinykeymap#Map('tabs', 'T', 'norm! gT') 
call tinykeymap#Map('tabs', "l", 'norm! gt')
call tinykeymap#Map('tabs', "h", 'norm! gT')
call tinykeymap#Map('tabs', "k", 'exec "tabmove" (max([1, tabpagenr() - 1]) - 1)')
call tinykeymap#Map('tabs', "j", 'exec "tabmove" (max([0, tabpagenr() - 1]) + 1)')
call tinykeymap#Map("tabs", "^", "tabfirst")
call tinykeymap#Map("tabs", "$", "tablast")
call tinykeymap#Map("tabs", "<Home>", "tabfirst")
call tinykeymap#Map("tabs", "<End>", "tablast")
call tinykeymap#Map("tabs", "c", "tabclose")
call tinykeymap#Map("tabs", "<Del>", "tabclose")
call tinykeymap#Map("tabs", "<BS>", "tabclose")
call tinykeymap#Map("tabs", "p", "call tinykeymap#tabs#Previous()", {'desc': 'Previous tab'})

if exists('g:loaded_tlib') && g:loaded_tlib > 0
    call tinykeymap#Map("tabs", "s", "tabnew +TScratch!", {'desc': 'Scratch tab', 'exit': 1})
endif

