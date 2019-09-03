set nocompatible
let mapleader = "\<space>"
let maplocalleader = ","
source ~/vimfiles/config/plugins.vim
set background=light
source ~/vimfiles/config/pluginsConfig.vim
source ~\vimfiles\config\cocConfig.vim
source ~/vimfiles/config/keybindings.vim
source ~/vimfiles/config/settings.vim
colorscheme gruvbox
if (!exists('g:first_load'))
    if v:vim_did_enter
      SessionLoad
    else
     au VimEnter * SessionLoad
    endif
endif
let g:first_load = v:false
