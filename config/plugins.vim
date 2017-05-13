call plug#begin('~/vimfiles/plugged')
Plug 'equalsraf/neovim-gui-shim'
Plug 'Tarmean/multi'
let g:python3_host_prog="C:\\Python36\\python.exe"
let g:python_host_prog="C:\\Python27\\python.exe"
if (has('python'))
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif
Plug 'ervandew/supertab'

Plug 'Shirk/vim-gas'
Plug 'rust-lang/rust.vim'
Plug 'spwhitt/vim-nix'

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'itchyny/calendar.vim'
Plug 'justinmk/vim-dirvish' 
Plug 'Konfekt/FastFold'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish', { 'on':  'S' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession', { 'on':  'Obsession' }
Plug 'dhruvasagar/vim-prosession' 

Plug 'ludovicchabant/vim-gutentags'
Plug 'dbakker/vim-projectroot'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on':  'Gitv' }
Plug 'jreybert/vimagit'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'
Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tommcdo/vim-exchange'

Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'Julian/vim-textobj-variable-segment'

Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(LiveEasyAlign)' }

Plug 'dhruvasagar/vim-table-mode', { 'on':  'TableModeEnable' }
Plug 'zah/nim.vim', { 'for': 'nim' }

Plug 'morhetz/gruvbox'
Plug 'Tarmean/lightline-gruvbox.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
let g:limelight_conceal_ctermfg = 242
if(has('gui'))
    let g:rainbow_active = 1
endif

if(has('nvim'))
    " let g:python3_host_prog='/usr/bin/python3'
    " let g:python_host_prog='/usr/bin/python'
    let g:python3_host_prog='/home/cyril/.nix-profile/bin/python3'

    " let g:python_host_prog='/home/cyril/.nix-profile/bin/python'
    function! DoRemote()
        UpdateRemotePlugins
    endfunction

    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'benekastah/neomake'
endif

if(has('unix'))
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
    Plug 'junegunn/fzf.vim'
    Plug 'nhooyr/fasd.vim'
else
    Plug 'Shougo/unite.vim', 
    noremap <leader>fc :<c-u>Unite colorscheme<cr>
    Plug 'tsukkee/unite-tag'
    Plug 'ujihisa/unite-colorscheme'
    Plug 'Shougo/neomru.vim'
    Plug 'scrooloose/syntastic' 
    let g:syntastic_check_on_wq = 0
endif

call plug#end()

silent! unmap <space>ig
