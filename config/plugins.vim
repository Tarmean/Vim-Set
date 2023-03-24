call plug#begin('~/vimfiles/plugged')
Plug 'github/copilot.vim'
Plug 'tpope/vim-sleuth'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tommcdo/vim-exchange'
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'tpope/vim-dispatch'
Plug 'Julian/vim-textobj-variable-segment'
if !exists('g:vscode')
    Plug 'vim-test/vim-test'
    " Plug 'rcarriga/vim-ultest'
    Plug 'neovimhaskell/nvim-hs.vim'
    Plug 'liuchengxu/vim-which-key'
    Plug 'lervag/vimtex'
    Plug 'Tarmean/Gistory'
    Plug 'Tarmean/term-utils.nvim'
    Plug 'puremourning/vimspector'
    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-repeat'
    if has('windows')
        " let g:python_host_prog="C:\\Python27\\python.exe"
        if has('nvim')
            let g:python3_host_prog="C:\\Python37\\python.exe"
        else
            let &pythonthreehome='C:\Python39'
            let &pythonthreedll='C:\Python39\python39.dll'
        endif
    else
        let g:python3_host_prog="/usr/bin/python3"
        " let g:python_host_prog="/usr/bin/python2"
    endif
    Plug 'derekelkins/agda-vim'
    Plug 'Tarmean/fzf-session.vim'
    Plug 'tpope/vim-obsession'
    Plug 'Tarmean/CsvHack.vim'
    Plug 'dhruvasagar/vim-table-mode', { 'on':  ['TableModeEnable', 'TableModeRealign'] }
    Plug 'FooSoft/vim-argwrap'
    Plug 'jiangmiao/auto-pairs'
    Plug 'yaymukund/vim-haxe'
    Plug '2072/PHP-Indenting-for-VIm'
    Plug 'chrisbra/Recover.vim'
    Plug 'rhysd/git-messenger.vim'
    Plug 'lumiliet/vim-twig'
    if has('nvim')
        Plug 'phaazon/hop.nvim'
    endif
    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
    Plug 'idris-hackers/idris-vim'
    Plug 'equalsraf/neovim-gui-shim'
    Plug 'Tarmean/multi'
    Plug 'Shirk/vim-gas'
    Plug 'rust-lang/rust.vim'
    Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
    Plug 'justinmk/vim-dirvish'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-abolish', { 'on':  'S' }
    Plug 'dbakker/vim-projectroot'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-speeddating'
    Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(LiveEasyAlign)' }
    Plug 'gruvbox-community/gruvbox'
    Plug 'itchyny/lightline.vim'
    Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
    Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
    let g:limelight_conceal_ctermfg = 242
    if(has('gui'))
        let g:rainbow_active = 1
    endif
    Plug 'kern/vim-es7'
    Plug 'othree/es.next.syntax.vim'
    Plug 'zah/nim.vim', { 'for': 'nim' }
    Plug 'StanAngeloff/php.vim', { 'for': 'php' }
    if(has('nvim'))
        function! DoRemote()
            UpdateRemotePlugins
        endfunction
    else
    endif
    Plug 'junegunn/fzf.vim'
    if(has('unix'))
        Plug 'nhooyr/fasd.vim'
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
    else
        Plug 'junegunn/fzf'
    endif
endif
call plug#end()
silent! unmap <space>ig
