"#####表示設定#####
set number "行番号を表示する
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け
set tabstop=4 "インデントをスペース4つ分に設定
set smartindent "オートインデント
"Tab、行末の半角スペースを明示的に表示する
set list
set listchars=tab:^\ ,trail:~
" ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set wrap


"#####検索設定#####
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る



"バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

"スペースでダウンアップ
nnoremap <Space>  <C-E>
nnoremap <C-Space> <C-Y>


" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" jjをESCキー
inoremap <silent> jj <esc>
" 挿入モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

set expandtab 
set tabstop=4
set shiftwidth=4
set softtabstop=4 
set autoindent
set smartindent

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" ---  ファイラーを起動 ---
nnoremap <silent><Space>j    :Explore<CR>


""""""""""""""""""""""""""""""
"挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
  autocmd!
  autocmd InsertEnter * call s:StatusLine('Enter')
  autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
 if a:mode == 'Enter'
   silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
   silent exec g:hi_insert
 else
   highlight clear StatusLine
   silent exec s:slhlcmd
 endif
endfunction

function! s:GetHighlight(hi)
 redir => hl
 exec 'highlight '.a:hi
 redir END
 let hl = substitute(hl, '[\r\n]', '', 'g')
 let hl = substitute(hl, 'xxx', '', '')
 return hl
endfunction

