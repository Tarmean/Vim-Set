" windows.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2014-04-14.
" @Revision:    47

if !exists('g:tinykeymap#map#windows#map')
    " Map leader for the "windows" tinykeymap.
    let g:tinykeymap#map#windows#map = g:tinykeymap#mapleader ."s"   "{{{2
endif


" Based on Andy Wokulas's windows mode for tinymode.
call tinykeymap#EnterMap("windows", g:tinykeymap#map#windows#map, {
            \ 'name': 'windows mode',
            \ 'message': 'winnr() .": ". bufname("%")'
            \ })
call tinykeymap#Map('windows', '<C-l>', '<count1> wincmd >', {'desc': 'Increase width'})
call tinykeymap#Map('windows', '<C-h>', '<count1> wincmd <', {'desc': 'Decrease width'})
call tinykeymap#Map('windows', '|', 'vertical resize <count>', {'desc': 'Set width'})
call tinykeymap#Map('windows', '<C-j>', 'resize +<count3>', {'desc': 'Increase height'})
call tinykeymap#Map('windows', '<C-k>', 'resize -<count3>', {'desc': 'Decrease height'})
call tinykeymap#Map('windows', '_', 'resize <count>', {'desc': 'Set height'})
call tinykeymap#Map('windows', '=', 'wincmd =', {'desc': 'Make equally high and wide'})
call tinykeymap#Map('windows', 'r', 'wincmd r', {'desc': 'Rotate window downwards/rightwards'})
" call tinykeymap#Map('windows', 'R', 'wincmd R', {'desc': 'Rotate window upwards/leftwards'})
" call tinykeymap#Map('windows', 'x', '<count>wincmd x', {'desc': 'Exchange windows'})
 call tinykeymap#Map('windows', 'K', 'wincmd K', {'desc': 'Move current window to the top'})
 call tinykeymap#Map('windows', 'J', 'wincmd J', {'desc': 'Move current window to the bottom'})
 call tinykeymap#Map('windows', 'H', 'wincmd H', {'desc': 'Move current window to the left'})
 call tinykeymap#Map('windows', 'L', 'wincmd L', {'desc': 'Move current window to the right'})
" call tinykeymap#Map('windows', 'T', 'wincmd T', {'desc': 'Move current window to a new tab page'})
" call tinykeymap#Map('windows', 'w', '<count>wincmd w', {'desc': 'Below-right window'})
" call tinykeymap#Map('windows', 'W', '<count>wincmd W', {'desc': 'Above-left window'})
 call tinykeymap#Map('windows', 'k', '<count>call WinMove("k")', {'desc': 'Window above'})
 call tinykeymap#Map('windows', 'j', '<count>call WinMove("j")', {'desc': 'Window below'})
 call tinykeymap#Map('windows', 'h', '<count>call WinMove("h")', {'desc': 'Left window'})
 call tinykeymap#Map('windows', 'l', '<count>call WinMove("l")', {'desc': 'Right window'})
" call tinykeymap#Map('windows', 't', 'wincmd t', {'desc': 'Top-left window'})
" call tinykeymap#Map('windows', 'b', 'wincmd b', {'desc': 'Bottom-right window'})
" call tinykeymap#Map('windows', 'p', 'wincmd p', {'desc': 'Previous window'})
" call tinykeymap#Map('windows', 'P', 'wincmd P', {'desc': 'Preview window'})
" call tinykeymap#Map('windows', 'c', 'wincmd c', {'desc': 'Close window'})
 call tinykeymap#Map('windows', 'w', 'wincmd o', {'desc': 'Make the only window', 'exit': 1})
 call tinykeymap#Map('windows', 'c', 'wincmd c', {'desc': 'Close current window'})
call tinykeymap#Map('windows', 'C', 'bdelete! <count>')
call tinykeymap#Map('windows', 'n', 'vnew', {'desc': 'New buffer'})
 call tinykeymap#Map('windows', 'q', ':<count>tab sp', {'desc': 'Move to new Tab'})
 call tinykeymap#Map('windows', 'a', ':vert ball', {'desc': 'Open all buffers'})
call tinykeymap#Map('windows', 's', 'split')
call tinykeymap#Map('windows', 'v', 'vert split')
call tinykeymap#Map('windows', "<Up>", 'wincmd W', {'exit': 1})
call tinykeymap#Map('windows', "<Down>", 'wincmd w', {'exit': 1})
call tinykeymap#Map('windows', "z", ':<count>JumpBackward', {'desc': 'Move window to left tab'})
call tinykeymap#Map('windows', "Z", ':<count>JumpForward', {'desc': 'Move window to left tab'})
call tinykeymap#Map('windows', "o", ':TabNext <count>', {'desc': 'Move to right Tab'})
call tinykeymap#Map('windows', "i", ':tabp <count>', {'desc': 'Move to left Tab'})
call tinykeymap#Map('windows', "I", ':call Clone_rel_tab_backwards(1, <count>)', {'desc': 'Next location'})
call tinykeymap#Map('windows', "O", ':call Clone_rel_tab_forwards(1, <count>)', {'desc': 'Previous location'})
call tinykeymap#Map('windows', "<C-U>", ':call Clone_rel_tab_backwards(0, <count>)', {'desc': 'Next location'})
call tinykeymap#Map('windows', "<C-I>", ':call Clone_rel_tab_forwards(0, <count>)', {'desc': 'Previous location'})
"call tinykeymap#Map('windows', "y", 'call Clone_rel_tab_backwards(1, <count>)', {'desc': 'Move window to left tab'})
"call tinykeymap#Map('windows', "x", 'call Clone_rel_tab_forwards(1, <count>)', {'desc': 'Move window to right tab'})
"call tinykeymap#Map('windows', "Y", 'call Clone_rel_tab_backwards(0, <count>)', {'desc': 'Open window to left tab'})
"call tinykeymap#Map('windows', "X", 'call Clone_rel_tab_forwards(0, <count>)', {'desc': 'Open window to right tab'})
