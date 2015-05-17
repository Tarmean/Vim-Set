function! AddPlugins(all)
    call plug#begin('~/vimfiles/plugged')
    Plug 'Konfekt/FastFold'
    Plug 'tpope/vim-obsession'
    Plug 'dhruvasagar/vim-prosession'
    Plug 'ervandew/supertab'
    Plug 'bling/vim-airline'
    Plug 'tpope/vim-fugitive'
    Plug 'gregsexton/gitv'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'bruno-/vim-vertical-move'
    Plug '~/vimOld/bundle/vim-unimpaired-master/'
    Plug '~/vimOld/bundle/filebeagle/'
    Plug '~/vimOld/bundle/delimitMate/'
    Plug '~/vimOld/bundle/mixedfunctions/'
    Plug '~/vimOld/bundle/convertBase/'

    if(a:all)
        Plug 'nathanaelkane/vim-indent-guides'
        Plug 'rking/ag.vim'
        Plug 'sjl/gundo.vim'
        Plug 'Shougo/neomru.vim'
        Plug 'godlygeek/tabular'
        Plug 'majutsushi/tagbar'
        if(has('python'))
            Plug 'SirVer/ultisnips'
            Plug 'honza/vim-snippets'
            let g:UltiSnipsExpandTrigger="<tab>"
            let g:UltiSnipsJumpForwardTrigger="<s-space>"
            let g:UltiSnipsJumpBackwardTrigger="<c-space>"
        endif
        Plug 'Shougo/unite.vim'
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
                    \ 'GotoNextMarker'     :  "[+",
                    \ 'GotoPrevMarker'     :  "[-",
                    \ 'GotoNextMarkerAny'  :  "]=",
                    \ 'GotoPrevMarkerAny'  :  "[=",
                    \ 'ListLocalMarks'     :  "m/",
                    \ 'ListLocalMarkers'   :  "m?"
                    \ }


        Plug 'dhruvasagar/vim-table-mode'
        Plug 'tpope/vim-commentary'
        Plug 'glts/vim-textobj-comment'
        Plug 'kana/vim-textobj-fold'
        Plug 'kana/vim-textobj-function'
        Plug 'kana/vim-textobj-indent'
        Plug 'kana/vim-textobj-line'
        Plug 'kana/vim-textobj-entire'
        Plug 'kana/vim-textobj-user'
        Plug 'Julian/vim-textobj-variable-segment'

        Plug '~/vimOld/bundle/targets.vim/'

        if(has('nvim'))
            Plug 'benekastah/neomake'
        else
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


        Plug '~/vimOld/bundle/vim-gitgutter-master' "Plug 'airblade/vim-gitgutter'
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


" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plugin outside ~/vimfiles/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
