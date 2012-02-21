scriptencoding utf-8

if exists('g:vimemo_loaded') && g:vimemo_loaded
  finish
endif

let s:save_cpoptions = &cpoptions
set cpoptions&vim

command VimemoOpen
      \ call vimemo#open()

let g:vimemo_loaded = 1

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

