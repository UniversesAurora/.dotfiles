" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

let skip_defaults_vim=1

set number
set smartindent
set cindent
set showmatch
set confirm
set tabstop=8
syntax on
set softtabstop=8
set shiftwidth=8
set ignorecase
set smartcase
set tagcase=match
set hlsearch
set incsearch
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1
set wildmenu
set whichwrap=b,s,<,>,[,]
set scrolloff=5
set laststatus=2
set autoread
set completeopt=preview,menu
set clipboard+=unnamed
set mouse=a
set selection=exclusive
set selectmode=mouse,key
set history=10000
set noexpandtab
set shiftround
set smarttab
set linebreak
set wrap
set ruler
set cursorline
set visualbell
set foldmethod=syntax
set nofoldenable
set cc=80
filetype plugin indent on

autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" For Windows
" hi CursorLine cterm=NONE ctermbg=black
