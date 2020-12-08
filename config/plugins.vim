call plug#begin('~/vimfiles/plugged')

Plug 'kien/rainbow_parentheses.vim'
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
Plug 'Julian/vim-textobj-variable-segment'


if !exists('g:vscode')
    Plug 'puremourning/vimspector'
    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-repeat'

    if has('windows')
        let g:python_host_prog="C:\\Python27\\python.exe"
        let g:python3_host_prog="C:\\Python38\\python.exe"
    else
        let g:python3_host_prog="/usr/bin/python3"
        let g:python_host_prog="/usr/bin/python2"
    endif

    Plug 'derekelkins/agda-vim'
    " Plug 'tveskag/nvim-blame-line'
    Plug 'Tarmean/fzf-session.vim'
    Plug 'tpope/vim-obsession'
    Plug 'Tarmean/CsvHack.vim'
    Plug 'dhruvasagar/vim-table-mode', { 'on':  ['TableModeEnable', 'TableModeRealign'] }

    Plug 'FooSoft/vim-argwrap'
    " Plug 'jiangmiao/auto-pairs'
    Plug 'yaymukund/vim-haxe'
    " Plug 'rayburgemeestre/phpfolding.vim'
    Plug '2072/PHP-Indenting-for-VIm'
    Plug 'chrisbra/Recover.vim'
    Plug 'rhysd/git-messenger.vim'
    " Plug 'roryokane/detectindent'
    " Plug 'vim-vdebug/vdebug'
    Plug 'lumiliet/vim-twig'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'idris-hackers/idris-vim'
    Plug 'equalsraf/neovim-gui-shim'
    Plug 'Tarmean/multi'
    if (has('python3'))
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'
    endif


    Plug 'Tarmean/multi'
    " Plug 'ervandew/supertab'

    Plug 'Shirk/vim-gas'
    Plug 'rust-lang/rust.vim'

    Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
    Plug 'justinmk/vim-dirvish' 
    " Plug 'Konfekt/FastFold'

    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-abolish', { 'on':  'S' }
    " Plug 'dhruvasagar/vim-prosession' 

    " Plug 'ludovicchabant/vim-gutentags'
    Plug 'dbakker/vim-projectroot'

    Plug 'tpope/vim-fugitive'

    Plug 'tpope/vim-speeddating'
    " Plug 'justinmk/vim-sneak'


    Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(LiveEasyAlign)' }


    Plug 'morhetz/gruvbox'
    Plug 'Tarmean/lightline-gruvbox.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
    Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
    " Plug 'junegunn/vim-peekaboo'
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

        " Plug 'Shougo/neco-syntax'
        " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    else
        " Plug 'scrooloose/syntastic' 
        " let g:syntastic_check_on_wq = 0
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
