scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:DEFAULT_OPTIONS = {
      \ 'directory': '~/vimemo/',
      \ 'file_name_format': '%Y-%m-%d.markdown'
      \ }

function! vimemo#open()
  let _ = s:get_file_name()
  execute 'edit' _
endfunction

function! vimemo#search(keyword)
  " TODO:
  let file = s:get_option('directory') . '**'
  let pattern = '\V' . escape(a:keyword, '\')
  execute 'lvimgrep' '/' . pattern . '/gj' file
  lopen
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

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

