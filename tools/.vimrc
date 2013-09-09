scriptencoding utf-8
set nocompatible

if has('vim_starting')
  filetype plugin off
  filetype indent off
  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
endif
call neobundle#rc(expand('~/.vim/bundle'))

NeoBundle 'git://github.com/kien/ctrlp.vim.git'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/scrooloose/nerdtree.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'

syntax on
filetype plugin on
filetype indent on

" SSH クライアントの設定によってはマウスが使える（putty だと最初からいける）
set mouse=n

"インサートモードでも移動
inoremap <c-d> <delete>
inoremap <c-h> <left>
inoremap <c-l> <right>
inoremap <c-j> <down>
inoremap <c-m> <esc>
