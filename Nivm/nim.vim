func! GetCommand(type)
    return printf("%s %s:%d:%d", a:type, expand("%"), line("."), col("."))
endfunc

func! s:JobHandler(job_id, data, event)
  echo data
  call getchar()
  if a:event == 'stdout'
    let str = self.nim.' stdout: '.join(a:data)
  elseif a:event == 'stderr'
    let str = self.nim.' stderr: '.join(a:data)
  else
    let str = self.nim.' exited'
  endif

  call append(line('$'), str)
endfunction
let s:callbacks = {
\ 'on_stdout': function('s:JobHandler'),
\ 'on_stderr': function('s:JobHandler'),
\ 'on_exit': function('s:JobHandler')
\ }

func! Start()
    let g:job1 = jobstart(['nimsuggest', '--stdin', '--v2', 'PloverAnalyzer.nim'], extend({'nim': 'nim  1'}, s:callbacks))
endfunc
