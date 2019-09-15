source ~/vimfiles/config/plugins.vim
source ~/vimfiles/config/settings.vim
source ~/vimfiles/config/keybindings.vim
source ~/vimfiles/config/cocconfig.vim
source ~/vimfiles/config/pluginsconfig.vim

if (!exists('g:first_load'))
    if v:vim_did_enter
      SessionLoad
    else
     au VimEnter * SessionLoad
    endif
endif
let g:first_load = v:false
