scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! vimemo#open()
  let _ = s:get_file_name()
  execute 'edit' _
endfunction

function! s:get_file_name()
  let format = s:get_option('file_name_format')
  let file_name = strftime(format)
  return file_name
endfunction

function! s:get_option(name)
  if !exists('g:vimemo_options')
    let g:vimemo_options = {}
  endif
  return get(g:vimemo_options, a:name, s:get_option_default(a:name))
endfunction

function! s:get_option_default(name)
  let defaults = {'file_name_format', '~/vimemo/%Y-%m-%d.txt'}
  return get(defaults, a:name, '')
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

