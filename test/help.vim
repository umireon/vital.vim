let s:suite = themis#suite('help')

function! s:suite.after() abort
  if filereadable('doc/tags')
    call delete('doc/tags')
  endif
endfunction

function! s:suite.make_helptags() abort
  " Detect E154
  helptags doc
endfunction

function! s:suite.__modules__() abort
  let modules = themis#suite('helptags for module')

  function! modules.before() abort
    helptags doc
  endfunction

  function! modules.__each_modules__() abort
    let V = vital#of('vital')
    for module_name in V.search('**')
      let module = V.import(module_name)
      let suite = themis#suite(module_name)
      for func_name in keys(module)
        let tagname = printf('Vital.%s.%s()', module_name, func_name)
        execute join([
        \   printf('function! suite.%s()', func_name),
        \   printf('  help %s', tagname),
        \   'endfunction',
        \ ], "\n")
      endfor
    endfor
  endfunction
endfunction
