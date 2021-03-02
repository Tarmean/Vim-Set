let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
source ~/vimfiles/config/plugins.vim
source ~/vimfiles/config/settings.vim
source ~/vimfiles/config/keybindings.vim
source ~/vimfiles/config/pluginsconfig.vim
set diffopt+=iwhiteall
if !exists('g:vscode')
    source ~/vimfiles/config/cocconfig.vim
else
    set fillchars+=vert:\▏
    let g:loaded_matchparen=1
endif

if (!exists('g:first_load') && argc() == 0)
    if v:vim_did_enter
      GuiTabline 0
      SessionLoad
    else
     au VimEnter * SessionLoad
     au VimEnter * GuiTabline 0
    endif
endif

let g:first_load = v:false
