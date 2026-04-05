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
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:qfhistory_var)
else
  let g:ctrlp_ext_vars = [s:qfhistory_var]
endif

" 1. リストの初期化: Quickfixの履歴を取得して整形する
function! ctrlp#qfhistory#init()
  let l:history = []
  " getqflist({'all': 1}) で全履歴を取得（Vim 8.0+ / Neovim）
  let l:qfall = getqflist({'all': 0, 'nr': '$'})
  let l:last_nr = l:qfall.nr

  for l:i in range(1, l:last_nr)
    let l:info = getqflist({'nr': l:i, 'title': 1})
    " 履歴番号とタイトルを組み合わせて表示用に整形
    call add(l:history, printf("%2d: %s", l:i, l:info.title))
  endfor

  return reverse(l:history) " 新しい履歴を上に表示
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
