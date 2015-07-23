function! AddPlugins(all)
    call plug#begin('~/vimfiles/plugged')
    Plug 'justinmk/vim-sneak'
    Plug 'jceb/vim-orgmode'
    Plug 'dbakker/vim-projectroot'
    Plug 'kana/vim-operator-user'
    Plug 'kana/vim-grex'
    Plug 'kana/vim-operator-replace'
    "Plug 'lambdalisue/vim-unified-diff'
    Plug 'sjl/splice.vim'
    Plug 'Konfekt/FastFold'
    Plug 'ervandew/supertab'
    Plug 'morhetz/gruvbox'
    "Plug 'bling/vim-airline'
    Plug 'itchyny/lightline.vim'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-speeddating'
    Plug 'tpope/vim-surround'
    Plug 'bruno-/vim-vertical-move'
    Plug '~/vimOld/bundle/vim-unimpaired-master/'
    Plug '~/vimOld/bundle/delimitMate/'
    Plug '~/vimOld/bundle/mixedfunctions/'

    Plug 'tpope/vim-commentary'
    Plug 'glts/vim-textobj-comment'
    Plug 'kana/vim-textobj-fold'
    Plug 'kana/vim-textobj-function'
    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-line'
    Plug 'kana/vim-textobj-entire'
    Plug 'kana/vim-textobj-user'
    Plug 'Julian/vim-textobj-variable-segment'
    Plug 'mhinz/vim-signify'
    if(a:all)
        Plug 'junegunn/seoul256.vim'
        Plug 'lambdalisue/vim-gita'
        Plug '~/vimOld/bundle/filebeagle/' 
        Plug 'tommcdo/vim-exchange'
        Plug 'tpope/vim-abolish', { 'on':  'S' }
        Plug 'tpope/vim-obsession', { 'on':  'Obsession' }
        Plug 'dhruvasagar/vim-prosession' " has to be loaded for auto complete on first use
        Plug '~/vimOld/bundle/convertBase/'
        " Plug 'vim-scripts/ingo-library'
        " Plug 'vim-scripts/CountJump'
        " Plug 'vim-scripts/ConflictMotions'
        " Plug 'vim-scripts/help_movement'
        " Plug 'vim-scripts/diffwindow_movement'


        Plug 'luochen1990/rainbow'
        if(has('gui'))
            "let g:rainbow_active = 1
        endif
        "Plug 'tpope/vim-fugitive'
        Plug 'artur-shaik/vim-javacomplete2'
        "Plug 'gregsexton/gitv', { 'on':  'Gitv' }
        Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
        Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
        let g:limelight_conceal_ctermfg = 242
        Plug 'Yggdroot/indentLine'
        "Plug 'gelguy/Cmd2.vim'
        "Plug 'junegunn/vim-after-object'
        "Plug 'junegunn/vim-peekaboo'
        Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
        Plug 'junegunn/vim-easy-align'
        Plug 'xolox/vim-easytags'
        Plug 'xolox/vim-misc'
        if(has('python'))
            Plug 'SirVer/ultisnips'
            Plug 'honza/vim-snippets'
        endif
        Plug 'kshenoy/vim-signature'
        let g:SignatureMap = {
                    \ 'Leader'             :  "m",
                    \ 'PlaceNextMark'      :  "m,",
                    \ 'ToggleMarkAtLine'   :  "m.",
                    \ 'PurgeMarksAtLine'   :  "m-",
                    \ 'DeleteMark'         :  "dm",
                    \ 'PurgeMarks'         :  "m<Space>",
                    \ 'PurgeMarkers'       :  "m<BS>",
                    \ 'GotoNextLineAlpha'  :  "']",
                    \ 'GotoPrevLineAlpha'  :  "'[",
                    \ 'GotoNextSpotAlpha'  :  "`]",
                    \ 'GotoPrevSpotAlpha'  :  "`[",
                    \ 'GotoNextLineByPos'  :  "]'",
                    \ 'GotoPrevLineByPos'  :  "['",
                    \ 'GotoNextSpotByPos'  :  "]s",
                    \ 'GotoPrevSpotByPos'  :  "[s",
                    \ 'GotoNextMarker'     :  "]ü",
                    \ 'GotoPrevMarker'     :  "[ä",
                    \ 'GotoNextMarkerAny'  :  "]ä",
                    \ 'GotoPrevMarkerAny'  :  "[ü",
                    \ 'ListLocalMarks'     :  "m/",
                    \ 'ListLocalMarkers'   :  "m?"
                    \ }

        Plug 'dhruvasagar/vim-table-mode', { 'on':  'TableModeEnable' }

        Plug '~/vimOld/bundle/targets.vim/'

        if(has('unix'))
            Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
        endif
        if(has('nvim'))
            let g:python_host_prog='/usr/bin/python'

            function! Get_classpath(ending)
                let project_root = ProjectRootGuess() . "/"
                let project_root .= a:ending
                return project_root
            endfunction

            Plug 'benekastah/neomake'
            autocmd BufWritePost * Neomake
        else
            Plug 'Shougo/unite.vim', 
            noremap <leader>fc :<c-u>Unite colorscheme<cr>

            Plug 'ujihisa/unite-colorscheme'
            Plug 'Shougo/neomru.vim'
            Plug '~/vimOld/bundle/syntastic-master/' 
            let g:syntastic_always_populate_loc_list = 1
            let g:syntastic_check_on_open = 1
            let g:syntastic_check_on_wq = 0
            let g:airline_exclude_preview=1
            set statusline+=%#warningmsg#
            set statusline+=%{SyntasticStatuslineFlag()}
            set statusline+=%*
            noremap ]os :SyntasticToggleMode<cr>
            noremap [os :SyntasticCheck<cr>
        endif


        "Plug '~/vimOld/bundle/vim-gitgutter-master' "Plug 'airblade/vim-gitgutter'
    endif
    call plug#end()
endfunction

if(has('nvim'))
    " move from the neovim terminal window to somewhere else
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    tnoremap <esc><esc> <C-\><C-n>
endif


silent! unmap <space>ig
" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plugin outside ~/vimfiles/plugged with post-update hook
