if exists('g:loaded_ctrlp_qfhistory') && g:loaded_ctrlp_qfhistory
  finish
endif
let g:loaded_ctrlp_qfhistory = 1

" CtrlPにこの拡張を登録するための変数
let s:qfhistory_var = {
  \ 'init': 'ctrlp#qfhistory#init()',
  \ 'accept': 'ctrlp#qfhistory#accept',
  \ 'lname': 'quickfix history',
  \ 'sname': 'qfhist',
  \ 'type': 'line',
  \ 'sort': 0,
  \ }

" CtrlP本体にこの拡張を追加
let g:ctrlp_ext_vars = get(g:, 'ctrlp_ext_vars', []) ->add(s:qfhistory_var)

" 1. リストの初期化: Quickfixの履歴を取得して整形する
function! ctrlp#qfhistory#init()
  return range(1, getqflist({'nr': '$'}).nr)
        \ ->map({_, val -> printf('%2d: %s', val, getqflist({'nr': val, 'title': 1}).title)})
        \ ->reverse()
endfunction

" 2. 選択時の動作: 選択された番号のQuickfixリストに切り替える
function! ctrlp#qfhistory#accept(mode, str)
  call ctrlp#exit()
  " 行頭の数字（履歴番号）を抽出
  let l:nr = matchstr(a:str, '^\s*\zs\d\+')
  if !empty(l:nr)
    execute 'chistory' l:nr
    copen
  endif
endfunction

" 3. 呼び出し用関数
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#qfhistory#id()
  return s:id
endfunction
