" File: autoload/health/scnvim.vim
" Author: David Granström
" Description: Health check

function! s:check_timers() abort
  if has('timers')
    call health#report_ok('has("timers") - success')
  else
    call health#report_warn(
          \ 'has("timers" - error)',
          \ 'scnvim needs "+timers" for eval flash'
          \ )
  endif
endfunction

function! s:check_sclang_executable() abort
  let user_sclang = get(g:, 'scnvim_sclang_executable')
  if !empty(user_sclang)
    call health#report_info('using g:scnvim_sclang_executable = ' . user_sclang)
  endif

  try
    let sclang = scnvim#util#find_sclang_executable()
    call health#report_info('sclang executable: ' . sclang)
  catch
    call health#report_error(
          \ 'could not find sclang executable',
          \ 'set g:scnvim_sclang_executable or add sclang to your $PATH'
          \ )
  endtry
endfunction

function! s:check_pynvim() abort
  if has('python3')
    call health#report_info('has("python3") - success')
  else
    call health#report_warn(
          \ 'could not find pynvim module for python3',
          \ 'check :help provider-python for more information'
          \ )
  endif
endfunction

function! s:check_pandoc_executable() abort
  let user_pandoc = get(g:, 'scnvim_pandoc_executable')
  if !empty(user_pandoc)
    call health#report_info('using g:scnvim_pandoc_executable = ' . user_pandoc)
  endif
  try
    let pandoc = scnvim#util#find_pandoc_executable()
    call health#report_info('pandoc executable: ' . pandoc)
  catch
    call health#report_info(
          \ 'could not find pandoc executable.',
          \ 'set g:scnvim_pandoc_executable or add pandoc to your $PATH'
          \ 'This is an optional dependency and only needed for SCDoc integration.',
          \ )
  endtry
endfunction

function! health#scnvim#check() abort
  call health#report_start('scnvim')
  call s:check_timers()
  call s:check_sclang_executable()
  call s:check_pandoc_executable()
  call s:check_pynvim()
endfunction
