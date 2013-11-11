set nobackup
set showmode
set showmatch
set number
set ignorecase
set t_Co=256
set showtabline=2

syntax on
colorscheme ir_black

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/


