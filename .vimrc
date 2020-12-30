set runtimepath+=~/.vim

" Use this group for any autocmd defined in this file.
augroup MyAutoCmd
  autocmd!
augroup END

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,sjis,euc-jp

" Fix 'fileencoding' to use 'encoding'
" if the buffer only continas 7-bit characters.
" Note that if the buffer is not 'modifiable',
" its 'fileencoding' cannot be changed, so that such buffers are skipped.
autocmd MyAutoCmd BufReadPost *
\ if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ | setlocal fileencoding=
\ | endif

set t_Co=256
set background=dark
colorscheme ir_black
syntax on

set autoindent
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/swap
set expandtab
set incsearch

" 特殊文字を可視化
" set listchars=tab:»\ ,extends:<,eol:↵,trail:\_
set listchars=tab:»\ ,extends:<,eol:«,trail:\_
set list
" 行末の改行を可視化
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/
" 全角スペースを可視化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
autocmd BufNewFile,BufRead * match ZenkakuSpace /　/

set number
set showmode
set showmatch
set smartindent
set smartcase
set smarttab
set whichwrap=b,s,h,l,<,>,[,]
set shiftwidth=2
set laststatus=2

set statusline=%{expand('%:p:t')}\ %<\(%{expand('%:p:h')}\)%=\ %m%r%y%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%3l,%3c]
set foldmethod=marker
set mouse=a
set backspace=indent,eol,start
set showtabline=2

autocmd BufNewFile,BufRead *.di set filetype=d

" visual モードで選択した領域を、クリップボードに保存する
" http://sanrinsha.lolipop.jp/blog/2013/01/10618.html
function! s:Paste64Copy() range
  let l:tmp = @"
  silent normal gvy
  let l:selected = @"
  let @" = l:tmp
  let l:i = 0
  let l:len = strlen(l:selected)
  let l:escaped = ''
  while l:i < l:len
    let l:c = strpart(l:selected, l:i, 1)
    if char2nr(l:c) < 128
      let l:escaped .= printf("\\u%04x", char2nr(l:c))
    else
      let l:escaped .= l:c
    endif
    let l:i += 1
  endwhile
  call system('echo -en "' . l:escaped . '" | pbcopy > /dev/tty')
  redraw!
endfunction

command! -range Paste64Copy :call s:Paste64Copy()

" paste 時に自動的に paste mode にする
" http://sanrinsha.lolipop.jp/blog/2013/01/10618.html
if $TMUX != ''
  let &t_SI = "\ePtmux;\e\e[?2004h\e\\"
  let &t_EI = "\ePtmux;\e\e[?2004l\e\\"
elseif $TERM == 'screen'
  let &t_SI = "\eP\e[?2004h\e\\"
  let &t_EI = "\eP\e[?2004l\e\\"
else
  let &t_SI = "\e[?2004h"
  let &t_EI = "\e[?2004l"
endif
let &pastetoggle = "\e[201~"
exec "set <F13>=\e[200~"
inoremap <F13> <C-o>:set paste<CR>

filetype plugin indent on

