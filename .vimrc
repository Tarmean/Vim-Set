set nocompatible
let mapleader = "\<space>"
source ~/vimfiles/plugins/plugins.vim
call AddPlugins(1)
set background=dark
colorscheme gruvbox
source ~/vimfiles/plugins/pluginsConfig.vim
source ~/vimfiles/plugins/settingsSecondary.vim
source ~/vimfiles/settings/core.vim
source ~/vimfiles/settings/keybindings.vim
source ~/vimfiles/settings/secondary.vim
" augroup FZF_DELETE
"     au!
"     au BufHidden term.*fzf bd <afile>
" augroup END
