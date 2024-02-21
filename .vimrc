let $NVIM_COC_LOG_LEVEL='all'

let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
function! IsReal() 
    return !exists('g:vscode') && (has('nvim') || has('vim'))
endfunc
source ~/vimfiles/config/plugins.vim
source ~/vimfiles/config/settings.vim
source ~/vimfiles/config/keybindings.vim
source ~/vimfiles/config/pluginsConfig.vim
set diffopt+=iwhiteall
if IsReal()
    source ~/vimfiles/config/cocConfig.vim
    let g:vimspector_base_dir='C:\Users\cyril.etienne.fahlen\vimfiles\plugged\vimspector'
else
    set fillchars+=vert:\▏
    let g:loaded_matchparen=1
endif

map <F2> z<left>
map <F3> z<right>
if (!exists('g:first_load') && argc() == 0 && has('nvim'))
    if v:vim_did_enter
      GuiTabline 0
      SessionLoad
    else
     au VimEnter * SessionLoad
     au VimEnter * GuiTabline 0
    endif
endif

let g:first_load = v:false

command! MarkAsShortlived setlocal bufhidden=wipe
if has('nvim')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +MarkAsShortlived"
  let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS . ' --bind "alt-a:select-all,alt-d:deselect-all"'
endif

command! TSimulator Term sim adler-simulator run
command! TVpa Term vpa adler-vpa run
command! TConSim Term con-sim adler-connector-adler run
command! TConVpa Term con-vpa adler-connector-vpa run
function Bootstrap()
    call feedkeys(":TSimulator\<CR>:TVpa\<CR>:TConSim\<CR>:TConVpa\<CR>:Term lohi\<CR>")
endfunc
