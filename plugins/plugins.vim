function! AddPlugins(all)
     call plug#begin('~/vimfiles/plugged')
     Plug 'lervag/vimtex'
     Plug 'jreybert/vimagit'
     Plug 'jiangmiao/auto-pairs'
     Plug 'itchyny/calendar.vim' ", { 'on': 'Calender' }
     Plug 'vimwiki/vimwiki'

     " Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'plaintex' }

     Plug 'tpope/vim-eunuch'
     Plug 'PProvost/vim-ps1', { 'for': 'ps1' }
     Plug 'kovisoft/slimv', { 'for': 'scheme' }
     Plug 'AndrewRadev/sideways.vim'
     Plug 'davidhalter/jedi-vim', { 'for': 'python' } 
     Plug 'wellle/targets.vim'
     " Plug 'terryma/vim-multiple-cursors'
 
     Plug 'arecarn/fold-cycle.vim'
     Plug 'AndrewRadev/splitjoin.vim'
     " Plug 'vim-scripts/repeatable-motions.vim'
     Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
     Plug 'dhruvasagar/vim-table-mode', { 'on':  'TableModeEnable' }
     " Plug 'KabbAmine/zeavim.vim'
     Plug 'vim-scripts/ReplaceWithRegister'
 
     Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
     Plug 'junegunn/limelight.vim', { 'on':  'Goyo' }
     let g:limelight_conceal_ctermfg = 242
     Plug 'tpope/vim-abolish', { 'on':  'S' }
 
     Plug 'tpope/vim-surround'
     Plug 'justinmk/vim-sneak'
     Plug 'lambdalisue/vim-unified-diff'
     Plug 'sjl/splice.vim'
     Plug 'vasconcelloslf/vim-interestingwords'
     Plug 'tommcdo/vim-exchange'
     "Plug 'junegunn/agl' <actually for command line
     Plug 'Konfekt/FastFold'
     Plug 'tpope/vim-obsession', { 'on':  'Obsession' }
     Plug 'dhruvasagar/vim-prosession' 
     Plug 'ervandew/supertab'
     Plug 'morhetz/gruvbox'
     ""Plug 'bling/vim-airline'
     Plug 'itchyny/lightline.vim'
     Plug 'tpope/vim-repeat'
     Plug 'tpope/vim-speeddating'
     Plug 'bruno-/vim-vertical-move'
     Plug 'dbakker/vim-projectroot'
 
     Plug 'ludovicchabant/vim-gutentags'
     Plug '~/vimOld/bundle/vim-unimpaired-master/'
     Plug '~/vimOld/bundle/filebeagle/' 
     Plug '~/vimOld/bundle/mixedfunctions/'
     " Plug '~/vimfiles/plugged/ranger.vim/'
     Plug 'Konfekt/FastFold'
 
     Plug 'glts/vim-textobj-comment'
     Plug 'kana/vim-textobj-fold'
     Plug 'kana/vim-textobj-function'
     Plug 'kana/vim-textobj-indent'
     Plug 'kana/vim-textobj-line'
     Plug 'kana/vim-textobj-entire'
     Plug 'kana/vim-textobj-user'
     Plug 'Julian/vim-textobj-variable-segment'
     if(a:all)
     "Plug 'junegunn/agl' <actually for command line
         Plug 'LucHermitte/lh-vim-lib', { 'for': 'c' }
         Plug 'LucHermitte/VimFold4C', { 'for': 'c' }
         Plug 'RyanMcG/vim-j', { 'for': 'j' }
         Plug 'zah/nim.vim', { 'for': 'nim' }
         " Plug 'junegunn/seoul256.vim'
         Plug '~/vimOld/bundle/convertBase/'
         " Plug 'jceb/vim-orgmode'
         "Plug 'junegunn/seoul256.vim'
         "Plug 'lambdalisue/vim-gita'
         " Plug 'vim-scripts/ingo-library'
         " Plug 'vim-scripts/CountJump'
         " Plug 'vim-scripts/ConflictMotions'
         " Plug 'vim-scripts/help_movement'
         " Plug 'vim-scripts/diffwindow_movement'
 
         " Plug 'artur-shaik/vim-javacomplete2'
         Plug 'luochen1990/rainbow'
         if(has('gui'))
             let g:rainbow_active = 1
         endif
         Plug 'tpope/vim-fugitive'
         Plug 'gregsexton/gitv', { 'on':  'Gitv' }
         Plug 'Yggdroot/indentLine', { 'on':  'IndentLinesToggle' }
         "Plug 'gelguy/Cmd2.vim'
         "Plug 'junegunn/vim-after-object'
         "Plug 'junegunn/vim-peekaboo'
         Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
         Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(LiveEasyAlign)' }
 
         " Plug 'xolox/vim-easytags'
         " Plug 'xolox/vim-misc'
          if (has('python'))
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
                    \ 'GotoNextSpotByPos'  :  "]ä",
                    \ 'GotoPrevSpotByPos'  :  "[ü",
                    \ 'GotoNextMarker'     :  "]ü",
                    \ 'GotoPrevMarker'     :  "[ä",
                    \ 'GotoNextMarkerAny'  :  "]Ä",
                    \ 'GotoPrevMarkerAny'  :  "[Ü",
                    \ 'ListLocalMarks'     :  "<space>m",
                    \ 'ListLocalMarkers'   :  "<space>M"
                    \ }

        Plug 'tpope/vim-commentary'
        Plug 'mhinz/vim-signify'

        " Plug '~/vimOld/bundle/targets.vim/'

        if(has('unix'))
            Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
            Plug 'junegunn/fzf.vim'
        endif
        if(has('nvim'))
            let g:python_host_prog='/usr/bin/python'

            Plug 'Shougo/deoplete.nvim', { 'on': 'DeopleteEnable'}
            Plug 'Shougo/neco-vim', { 'on': 'DeopleteEnable'}

            "Plug 'Valloric/YouCompleteMe'
            " Plug 'critiqjo/lldb.nvim'

            function! Get_classpath(ending)
                let project_root = ProjectRootGuess() . "/"
                let project_root .= a:ending
                return project_root
            endfunction

            Plug 'benekastah/neomake'
            autocmd BufWritePost * Neomake
        else
            " Plug 'Shougo/neocomplete.vim'
            Plug 'Shougo/unite.vim', 
            noremap <leader>fc :<c-u>Unite colorscheme<cr>
            Plug 'tsukkee/unite-tag'
            Plug 'ujihisa/unite-colorscheme'
            Plug 'Shougo/neomru.vim'
            Plug 'scrooloose/syntastic' 
            " let g:syntastic_always_populate_loc_list = 1
            " let g:syntastic_check_on_open = 1
            let g:syntastic_check_on_wq = 0
            " let g:airline_exclude_preview=1
            " set statusline+=%#warningmsg#
            " set statusline+=%{SyntasticStatuslineFlag()}
            " set statusline+=%*
             noremap ]os :SyntasticToggleMode<cr>
             noremap [os :SyntasticCheck<cr>
        endif


        "Plug '~/vimOld/bundle/vim-gitgutter-master' "Plug 'airblade/vim-gitgutter'
    endif
    call plug#end()
endfunction

if(has('nvim'))
    "Plug 'ervandew/supertab'
    " move from the neovim terminal window to somewhere else
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    tnoremap ö <C-\><C-n>
endif


silent! unmap <space>ig
