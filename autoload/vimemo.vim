scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:DEFAULT_OPTIONS = {
      \ 'directory': '~/vimemo/',
      \ 'file_name_format': '%Y-%m-%d.markdown',
      \ 'max_loclist_height': 0
      \ }

function! vimemo#open()
  return s:open()
endfunction

function! vimemo#search(keyword)
  return s:search(a:keyword)
endfunction

function! s:open()
  let _ = s:get_file_name()
  execute 'edit' _
endfunction

function! s:search(keyword)
  " TODO:
  let file = s:get_option('directory') . '**'
  let pattern = '\V' . escape(a:keyword, '\')
  execute 'lvimgrep' '/' . pattern . '/gj' file
  let list = getloclist(0)
  if len(list) ==# 0
    return
  endif
  lopen
  let max_height = s:get_option('max_loclist_height')
  call s:fit_loclist(max_height)
endfunction

function! s:get_file_name()
  let dir = s:get_option('directory')
  let format = s:get_option('file_name_format')
  let name = strftime(dir . format)
  return name
endfunction

function! s:get_option(name)
  if !exists('g:vimemo_options')
    let g:vimemo_options = {}
  endif
  return get(g:vimemo_options, a:name, s:get_option_default(a:name))
endfunction

function! s:get_option_default(name)
  return get(s:DEFAULT_OPTIONS, a:name, '')
endfunction

function! s:fit_loclist(max_height)
  let list = getloclist(0)
  let current = len(list)
  let height = a:max_height <=# 0 ? current : s:min(current, a:max_height)
  execute 'resize' height
endfunction

function! s:min(value1, value2)
  if a:value1 <=# a:value2
    return a:value1
  else
    return a:value2
  endif
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

