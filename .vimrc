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
    let g:vimspector_base_dir='~\vimfiles\plugged\vimspector'
else
    set fillchars+=vert:\▏
    let g:loaded_matchparen=1
endif

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
endif
