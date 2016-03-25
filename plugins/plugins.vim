function! AddPlugins(all)
     call plug#begin('~/vimfiles/plugged')
     Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
     Plug 'itchyny/calendar.vim'
     Plug 'justinmk/vim-dirvish' 
     Plug 'sk1418/HowMuch', { 'on': 'HowMuch' }

     " Plug 'labdalisue/vim-unified-diff'
     Plug '~/vimOld/bundle/mixedfunctions/'
     Plug 'Konfekt/FastFold'

     Plug '~/vimOld/bundle/vim-unimpaired-master/'
     Plug 'tpope/vim-eunuch'
     Plug 'tpope/vim-abolish', { 'on':  'S' }
     Plug 'tpope/vim-repeat'
     Plug 'tpope/vim-obsession', { 'on':  'Obsession' }
     Plug 'dhruvasagar/vim-prosession' 
     Plug 'arecarn/fold-cycle.vim'
     " Plug 'jiangmiao/auto-pairs'

     Plug 'LucHermitte/lh-vim-lib'
     Plug 'LucHermitte/lh-tags'
     Plug 'LucHermitte/lh-dev'
     Plug 'LucHermitte/lh-brackets'    

     Plug 'ludovicchabant/vim-gutentags'
     Plug 'dbakker/vim-projectroot'
     Plug 'vasconcelloslf/vim-interestingwords'
     Plug 'ervandew/supertab'

    if (has('python'))
        " Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'
    endif
     Plug '~/vimOld/bundle/convertBase/'

     Plug 'mhinz/vim-signify'
     Plug 'tpope/vim-fugitive'
     Plug 'gregsexton/gitv', { 'on':  'Gitv' }
     Plug 'jreybert/vimagit'
     Plug 'sjl/splice.vim'

     Plug 'tpope/vim-surround'
     Plug 'tpope/vim-commentary'
     Plug 'tpope/vim-speeddating'
     Plug 'justinmk/vim-sneak'
     Plug 'wellle/targets.vim'
     Plug 'vim-scripts/ReplaceWithRegister'
     Plug 'bruno-/vim-vertical-move'
     Plug 'tommcdo/vim-exchange'
     Plug 'AndrewRadev/splitjoin.vim'

     Plug 'kana/vim-textobj-user'
     Plug 'glts/vim-textobj-comment'
     Plug 'kana/vim-textobj-fold'
     Plug 'kana/vim-textobj-function'
     Plug 'kana/vim-textobj-indent'
     Plug 'kana/vim-textobj-line'
     Plug 'kana/vim-textobj-entire'
     Plug 'Julian/vim-textobj-variable-segment'
     Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(LiveEasyAlign)' }

     Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
     Plug 'dhruvasagar/vim-table-mode', { 'on':  'TableModeEnable' }
     Plug 'LucHermitte/VimFold4C', { 'for': 'c' }
     Plug 'RyanMcG/vim-j', { 'for': 'j' }
     Plug 'zah/nim.vim', { 'for': 'nim' }

     Plug 'morhetz/gruvbox'
     Plug 'itchyny/lightline.vim'
     Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
     Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
     let g:limelight_conceal_ctermfg = 242
     Plug 'luochen1990/rainbow'
     if(has('gui'))
         let g:rainbow_active = 1
     endif

     if(has('unix'))
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
        Plug 'junegunn/fzf.vim'
        Plug 'nhooyr/fasd.vim'

        if(has('nvim'))
            tnoremap ö <C-\><C-n>

            let g:python3_host_prog='/usr/bin/python3'
            let g:python_host_prog='/usr/bin/python'
            Plug 'Shougo/deoplete.nvim', { 'on': 'DeopleteEnable'}
            Plug 'Shougo/neco-vim', { 'on': 'DeopleteEnable'}
            Plug 'zchee/deoplete-jedi', { 'on': 'DeopleteEnable'}

            Plug 'benekastah/neomake'
            autocmd BufWritePost * Neomake

            function! Get_classpath(ending)
                let project_root = ProjectRootGuess() . "/"
                let project_root .= a:ending
                return project_root
            endfunction
        else
            Plug 'Shougo/unite.vim', 
            noremap <leader>fc :<c-u>Unite colorscheme<cr>
            Plug 'tsukkee/unite-tag'
            Plug 'ujihisa/unite-colorscheme'
            Plug 'Shougo/neomru.vim'
            Plug 'scrooloose/syntastic' 
            let g:syntastic_check_on_wq = 0
             noremap cos :SyntasticToggleMode<cr>
        endif
    endif
 
     if(a:all)
        " Plug 'kshenoy/vim-signature'
        " let g:SignatureMap = {
        "             \ 'Leader'             :  "m",
        "             \ 'PlaceNextMark'      :  "m,",
        "             \ 'ToggleMarkAtLine'   :  "m.",
        "             \ 'PurgeMarksAtLine'   :  "m-",
        "             \ 'DeleteMark'         :  "dm",
        "             \ 'PurgeMarks'         :  "m<Space>",
        "             \ 'PurgeMarkers'       :  "m<BS>",
        "             \ 'GotoNextLineAlpha'  :  "']",
        "             \ 'GotoPrevLineAlpha'  :  "'[",
        "             \ 'GotoNextSpotAlpha'  :  "`]",
        "             \ 'GotoPrevSpotAlpha'  :  "`[",
        "             \ 'GotoNextLineByPos'  :  "]'",
        "             \ 'GotoPrevLineByPos'  :  "['",
        "             \ 'GotoNextSpotByPos'  :  "]ä",
        "             \ 'GotoPrevSpotByPos'  :  "[ü",
        "             \ 'GotoNextMarker'     :  "]ü",
        "             \ 'GotoPrevMarker'     :  "[ä",
        "             \ 'GotoNextMarkerAny'  :  "]Ä",
        "             \ 'GotoPrevMarkerAny'  :  "[Ü",
        "             \ 'ListLocalMarks'     :  "<space>m",
        "             \ 'ListLocalMarkers'   :  "<space>M"
        "             \ }

    endif
    call plug#end()
endfunction

silent! unmap <space>ig
