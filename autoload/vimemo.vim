scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:DEFAULT_OPTIONS = {
      \ 'directory': '~/vimemo/',
      \ 'file_name_format': '%Y-%m-%d.markdown',
      \ 'max_loclist_height': 0
      \ }

function! vimemo#open()
  return s:open_newfile()
endfunction

function! vimemo#list()
  return s:search_regexp('\%1l')
endfunction

function! vimemo#search(keyword)
  return s:search_fixed_string(a:keyword)
endfunction

function! s:open_newfile()
  let dir = s:get_directory()
  if !s:directory_exists(dir) && s:confirm_mkdir(dir)
    call s:mkdir_noexception(dir, 'p')
  endif
  let _ = s:get_file_name()
  execute 'hide' 'edit' _
endfunction

function! s:search_fixed_string(keyword)
  let pattern = '\V' . escape(a:keyword, '\')
  return s:search_regexp(pattern, 'g')
endfunction

function! s:search_regexp(pattern, ...)
  let option = get(a:000, 0, '')
  " TODO:
  let file = s:get_directory() . '**'
  execute 'silent!' 'lvimgrep' '/' . a:pattern . '/j' . option file
  let list = getloclist(0)
  if len(list) ==# 0
    return
  endif
  lopen
  let max_height = s:get_option('max_loclist_height')
  call s:fit_loclist(max_height)
endfunction

function! s:get_file_name()
  let dir = s:get_directory()
  let format = s:get_option('file_name_format')
  let name = strftime(dir . format)
  return name
endfunction

function! s:get_directory()
  let dir = s:get_option('directory')
  return fnamemodify(dir, ':p')
endfunction

function! s:directory_exists(directory)
  return filewritable(a:directory) == 2
endfunction

function! s:mkdir_noexception(...)
  try
    call call('mkdir', a:000)
    return 1
  catch
    return 0
  endtry
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

function! s:confirm_mkdir(directory)
  let msg = printf('mkdir ''%s''', a:directory)
  let choices = join(['&Yes', '&No'], "\n")
  let default = 1 " 1:&Yes
  let type = 'Question'
  return confirm(msg, choices, default, type) == 1
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

