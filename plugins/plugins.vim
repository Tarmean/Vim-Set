function! AddPlugins(all)
    call plug#begin('~/vimfiles/plugged')
    Plug 'tpope/vim-abolish', { 'on':  'S' }
    Plug 'justinmk/vim-sneak'
    Plug 'junegunn/vim-lengthmatters', {'on': 'LengthmattersEnable'}
    "Plug 'junegunn/agl' <actually for command line
    Plug 'Konfekt/FastFold'
    Plug 'tpope/vim-obsession', { 'on':  'Obsession' }
    Plug 'dhruvasagar/vim-prosession' " has to be loaded for auto complete on first use
    Plug 'ervandew/supertab'
    Plug 'junegunn/seoul256.vim'
    Plug 'morhetz/gruvbox'
    Plug 'bling/vim-airline'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'bruno-/vim-vertical-move'
    Plug '~/vimOld/bundle/vim-unimpaired-master/'
    Plug '~/vimOld/bundle/filebeagle/' " Probably would work after switching the mapping to Filebeagle but I use it too often too care.
    Plug '~/vimOld/bundle/delimitMate/'
    Plug '~/vimOld/bundle/mixedfunctions/'
    Plug '~/vimOld/bundle/convertBase/', { 'on':  'C' }

    if(a:all)
        Plug 'tpope/vim-fugitive'
        Plug 'gregsexton/gitv', { 'on':  'Gitv' }

        Plug 'kien/rainbow_parentheses.vim'
        Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
        Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
        Plug 'Yggdroot/indentLine'
        "Plug 'gelguy/Cmd2.vim'
        "Plug 'junegunn/vim-after-object'
        "Plug 'junegunn/vim-peekaboo'
        Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
        Plug 'junegunn/vim-easy-align' ", { 'on':  'Tabular' }
        Plug 'majutsushi/tagbar', { 'on':  'Tagbar' }
        if(has('python'))
            Plug 'SirVer/ultisnips'
            Plug 'honza/vim-snippets'
            let g:UltiSnipsExpandTrigger="<tab>"

            let g:UltiSnipsJumpBackwardTrigger="<c-space>"
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
        Plug 'tpope/vim-commentary'
        "Plug 'glts/vim-textobj-comment'
        Plug 'kana/vim-textobj-fold'
        Plug 'kana/vim-textobj-function'
        Plug 'kana/vim-textobj-indent'
        Plug 'kana/vim-textobj-line'
        Plug 'kana/vim-textobj-entire'
        Plug 'kana/vim-textobj-user'
        Plug 'Julian/vim-textobj-variable-segment'
        Plug 'mhinz/vim-signify'

        Plug '~/vimOld/bundle/targets.vim/'

        if(has('nvim'))
            Plug 'benekastah/neomake', { 'on':  'Neomake' }
            Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
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
