if exists(':Delete')
    delcommand Delete
endif

au BufNewFile,BufRead *.agda setf agda
au BufNewFile,BufRead *.lagda.md setf agda





let g:gistory_format_ft = {'hs': 0}
if (has('nvim'))
    command! -bang PHPShell RTerm<bang> php php -a -d auto_prepend_file=bootstrap_application.php
    nnoremap ö :call term_utils#term_toggle('insert', term_utils#guess_term_tag(), exists("b:term_hide") && b:term_hide)<cr>
    noremap Ö :call term_utils#term_toggle('normal', term_utils#guess_term_tag(), v:true)<cr>
    tnoremap ö <C-\><C-n>:call term_utils#goto_old_win(exists("b:term_hide") && b:term_hide)<cr>
    tnoremap Ö <C-\><C-n>
    " cnoremap term Term
    command! -bang TermHide :let b:hide_term='<bang>'==''
endif

let g:sleuth_automatic = 0
let g:detect_indent_files = {'php': 1}
augroup IndentDetect
  au!
  auto BufReadPost,BufNewFile *.php Sleuth
augroup END

nnoremap gx :exec "!&'C:\\Program Files\\Mozilla Firefox\\firefox.exe' " . expand("<cfile>") <cr>
let g:textobj_comment_no_default_key_mappings = 1
omap Ac <Plug>(textobj-comment-big-a)
omap ac <Plug>(textobj-comment-a)
omap ic <Plug>(textobj-comment-i)
nmap vAc v<Plug>(textobj-comment-big-a)
nmap vac v<Plug>(textobj-comment-a)
nmap vic v<Plug>(textobj-comment-i)
nmap _  <Plug>ReplaceWithRegisterOperator
nmap __ <Plug>ReplaceWithRegisterOperatorik
nmap <space>_ "+_
if exists("g:vscode")
    finish
endif
augroup DirvishMappings
  autocmd!
  autocmd filetype dirvish nmap <buffer> q <plug>(dirvish_quit)
  autocmd filetype dirvish  exec "lcd " .expand("%:p")
    
  " autocmd bufreadpost fugitive://* set bufhidden=wipe
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd BufReadPost quickfix nnoremap <buffer> J :cnext<cr>
  autocmd BufReadPost quickfix nnoremap <buffer> K :cprev<cr>
augroup end
nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround
nnoremap <space>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1
func! Seek(line, col, syn, dir)
    let line = a:line
    let col = a:col
    while synID(line, col+a:dir, 1) == a:syn
      let col += a:dir
      if (col == 0) || (col ==  col('$'))
          let line += a:dir
      endif
    endwhile
    return [0, line, col, 0]
endfunc
func! SelectHighlight()
   let cl = line(".")
   let cc = col(".")
   let cs = synID(cl, cc, 1)
   if cs == 0
       return
   endif
   let start = Seek(cl, cc, cs, -1)
   let end = Seek(cl, cc, cs, 1)
   return ['v', start, end]
endfunc

call textobj#user#plugin('highlight', {
\   '-': {
\     'select-a-function': 'SelectHighlight',
\     'select-a': 'ah',
\     'select-i-function': 'SelectHighlight',
\     'select-i': 'ih',
\   },
\ })

noremap <silent> - :call Dirvish_wrap_up(expand('%'))<cr>
if !exists("g:Dirvish_Added")
    let g:Dirvish_Added = 1
    au FileType dirvish call s:dirvish_init()
endif
func! s:dirvish_init()
    noremap <buffer><silent> - :call Dirvish_wrap_up('%:h:h')<cr>
    noremap <buffer><silent> h :call Dirvish_wrap_up('%:h:h')<cr>
    nnoremap <buffer><silent>  l :<c-u>.call dirvish#open("edit", 0)<cr>
    xnoremap <buffer><silent>  l :call dirvish#open("edit", 0)<cr>
    noremap <buffer> <cr> :
    nnoremap <buffer> + :e %
    nmap <expr><buffer> <esc> v:hlsearch?":noh\<cr>":"\<Plug>(dirvish_quit)"
    " skip both dirvish's and my mappings because \v isn't needed for file paths
    nnoremap <buffer> / /
    nnoremap <buffer> ? ?
    cnoremap <expr><buffer> <cr> Dirvish_append_search()
    set ma
    sort r /[^\/]$/
endfunc
func! Dirvish_wrap_up(path) " au */tomatically seek the directory or file when going up
    silent! execute "Dirvish " . a:path
    let loc = escape(substitute(expand("%:p"), '/', '\', 'g'), '\')
    " execute "lcd ".a:path
    call search( loc . '$')
endfunc
func! Dirvish_append_search()
    let isSearch = !(getcmdtype() == "/" || getcmdtype() == "?")
    let isEscaped = getcmdline() =~# '\ze[^\/]*[\/]\=\$$'
    if isSearch || isEscaped
        return "\<cr>"
    else
        return '\ze[^\/]*[\/]\=$'
    endif
endfunc
let g:tf_workaround= 0
noremap ]oz :Goyo!<cr>
noremap [oz :Goyo<cr>:IndentLinesDisable<cr>
let g:prosession_on_startup = 0

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus'], ['readonly', 'gitversion', 'filename'] ],
      \   'right': [ [ 'sleuth', 'lineinfo', 'percent', 'modified' ],
      \              [ 'filetype']]
      \ },
      \ 'inactive': {
            \ 'left': [ ['gitversion', 'filename']],
            \ 'right': [ [ 'lineinfo', 'percent' ], [], [], [] ] },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \ },
      \ 'component': {
      \   'gitversion': '%{LightLineGitversion()}',
      \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'sleuth': '%{SleuthIndicator()}'},
      \ 'component_expand': {
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'lineinfo': '(winwidth(0) >= 70)',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
function! FugitiveBufferIdent(...)
  let path = a:0 > 0 ? a:1 : expand("%")
  let p = tr(path, '\', '/')
  return matchlist(p, '\c^fugitive:\%(//\)\=\(.\{-\}\)\%(//\|::\)\(\x\{40,\}\|[0-3]\)\(/.*\)\=$')
endfunc
function! LightLineGitversion()
  let l:ls = FugitiveBufferIdent()
  if len(l:ls) == 0
      if &diff
          let out = 'working copy'
      else
          let out = FugitiveHead(7)
      endif
  else
      let l:idx = l:ls[2]
      if l:idx == '0'
          let out = 'index'
      elseif l:idx == '2'
          let out = 'target'
      elseif l:idx == '3'
          let out = 'merge'
      else
          let out = l:idx[0:6]
      endif
  endif
  if (len(out) != 0)
      let out = '[' . out . ']'
  endif
  return out
endfunction
augroup PluginAutocomands
    autocmd!
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
    autocmd User FzfStatusLine call <SID>fzf_statusline()
    autocmd ColorScheme * call s:lightline_update()
augroup END
function! s:lightline_update()
    if !exists('g:loaded_lightline')
        return
    endif
    try
        call LoadLightlineGruvbox()
        if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow\|gruvbox'
          let g:lightline.colorscheme =
            \substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
          call lightline#init()
          call lightline#colorscheme()
          call lightline#update()
    endif
  catch
  endtry
endfunction
fun! JumpToDef()
    if exists("*GotoDefinition_" . &filetype)
        call GotoDefinition_{&filetype}()
    else
        exe "norm! \<C-]>"
    endif
endf
if(has('nvim'))
    command! -nargs=* Z :call Z(<f-args>)
    function! Z(...)
        let cmd = 'fasd -d -e printf'
        for arg in a:000
            let cmd = cmd . ' ' . arg
        endfor
        let path = system(cmd)
        if isdirectory(path)
            echo path
            exec 'cd ' . path
        endif
    endfunction
    function! s:fzf_statusline()
        " Override statusline as you like
        highlight fzf1 ctermfg=161 ctermbg=251
        highlight fzf2 ctermfg=23 ctermbg=251
        highlight fzf3 ctermfg=237 ctermbg=251
        setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endfunction
    let g:fzf_layout = { 'window': 'enew' }
    " Advanced customization using autoload functions
    func! Fzf_remap()
          command! BTags call fzf#vim#btags(<q-args>, { 'window': 'enew' })
    endfunc
    function! Tag_or_reload(command)
        if (&tags == '')
            call gutentags#rescan()
        endif
        execute a:command
    endfunc
    nnoremap <silent> <leader><leader> :call Git_dir('GitFiles')<cr>
    nnoremap <silent> <leader>fm :Marks<cr>
    nnoremap <silent> <leader>ff :Buffers<cr>
    nnoremap <silent> <leader>fl :BLines<cr>
    nnoremap <silent> <leader>fd :Buffers term://<cr>
    nnoremap <silent> <leader>fw :Windows<cr>
    nnoremap <silent> <leader>fs :History<cr>
    nnoremap <silent> <leader>fc :call Git_dir("Commits")<cr>
    nnoremap <silent> <leader>fb :call Git_dir("Commits")<cr>
endif
au VimEnter * let g:fzf_commits_log_options = '--all --color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')
cabbrev git Git
nnoremap <space>ga :execute 'Git add ' . expand('%:p')<CR>
nnoremap <space>gs :Git<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <silent> <leader>gb :Gblame -wccc<cr>
vnoremap <space>gl :Gistory<cr>
nnoremap <space>gl :Gistory<cr>

command! -bang -range=% -nargs=? Flog call LineLog(<bang>0, '<line1>', '<line2>', '<args>')
function! LineLog(bang, top, bot, a)
    vs
    let file = expand("%:p")
    let cmd = 'git log -w'
    if !empty(a:a)
        let cmd .= " -S" . a:a
    endif
    if a:top != 1 || a:bot != line("$")
        let cmd .= ' -L '. a:top . ',' . a:bot . ':' . file
    else
        let cmd .= ' -p '.  file
    endif
    if !a:bang
        echo cmd
        call Git_dir('term ' . cmd)
        norm! i
    else
        call Git_dir('term')
        call feedkeys("i" . cmd, 'n')
    endif
endfunc
function! Git_dir(command)
    let l:old_cd = getcwd()
    let l:new_root = FugitiveWorkTree()
    if ('' == l:new_root)
        let l:new_root = l:old_cd
    endif
    execute 'lcd '.l:new_root
    execute a:command
    execute 'lcd '.l:old_cd
endfunction
vnoremap dp :diffput<cr>
vnoremap do :diffget<cr>
" vmap <leader>r <Plug>(EasyAlign)
" nmap <leader>r <Plug>(EasyAlign)
" nmap <leader>r <Plug>(LiveEasyAlign)
" vmap <leader>r <Plug>(LiveEasyAlign)
nnoremap <a-j> <c-e>
nnoremap <a-k> <c-y>

function! pluginsConfig#get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
vnoremap ' :Rg =pluginsConfig#get_visual_selection()<cr><cr>
nnoremap ' :Rg =expand("<cword>")<cr><cr>

function! s:rg_in_root(args, bang)
      let old = getcwd()
      let pat = a:args
      let cmd = "rg --column --line-number --no-heading --color=always --smart-case "
      while (l:pat[0] == '-')
          let head = matchstr(l:pat, "-\\S\\+\\s*")
          let pat = pat[len(l:head):]
          if (l:head[:3] == '-- ')
              break
          endif
          let cmd = l:cmd . " " . l:head
      endwhile
      let cmd = l:cmd . " -- "
      if !a:bang
          exec "cd " . FugitiveExtractGitDir(expand('%:p')) . "/.."
      endif
      call fzf#vim#grep(l:cmd . '"' . escape(l:pat, "\"")  . '"', 1, fzf#vim#with_preview(),  0 )
      exec "cd " . l:old
endfunc
command!      -bang -nargs=* Rg  call s:rg_in_root(<q-args>, <bang>0)
let g:fzf_preview_window = []
