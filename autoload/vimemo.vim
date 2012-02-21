scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! vimemo#open()
  edit ~/vimemo.txt
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

