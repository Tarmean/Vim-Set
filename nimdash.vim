" Dash integration for objc and nimrod.
command! DashNim !open -g dash://nimrod:"<cword>"
command! DashDef !open -g dash://def:"<cword>"
nmap K :DashDef<CR>\|:redraw!<CR>
au FileType nim  nmap K :DashNim<CR>\|:redraw!<CR>
