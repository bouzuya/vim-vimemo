scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! vimemo#open()
  let _ = s:get_file_name()
  execute 'edit' _
endfunction

function! s:get_file_name()
  let _ = strftime('~/vimemo/%Y-%m-%d.txt')
  return _
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

