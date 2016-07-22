set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'EinfachToll/DidYouMean'
Plugin 'sjl/gundo.vim'
Plugin 'haya14busa/incsearch.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'chilicuil/nextCS'
Plugin 'qwertologe/nextval.vim'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/syntastic'
Plugin 'eparreno/vim-l9'
Plugin 'othree/vim-autocomplpop'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'junegunn/vim-easy-align'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/taglist.vim'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'elzr/vim-json'
Plugin 'ktonga/vim-follow-my-lead'


" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"
"
" 以下開始是自訂設定
"
" basic
syntax on
set expandtab
set sw=4
set ts=4
set sts=4
set bs=2
set autoindent
set smartindent
set hlsearch
filetype plugin on
set langmenu=en
map <C-q> :q<CR>
" 顯示第80行
if (exists('+colorcolumn'))
    set colorcolumn=81
    highlight ColorColumn ctermbg=blue
endif
" 存檔時去除列尾空白
autocmd BufWritePre * %s/\s\+$//e
" 開檔時回到上一次存檔位置
autocmd BufReadPost * normal `"
" 行列高亮度顯示
" map <F8> :set cursorcolumn!<Bar>set cursorline!<CR>
" 檔案編碼偵測
set fencs=utf-8,big5,euc-jp,utf-16le
" 設定tab切換熱鍵
map <C-k> :tabn<CR>
map <C-j> :tabp<CR>
map <C-n> :tabnew<CR>
" ezbar
let g:ezbar_enable   = 1
" php自動完成
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" 把tpl當html檔看待
au BufRead,BufNewFile *.tpl set filetype=html
" 檢查檔案有沒有被其他編輯器動過
au CursorMoved * checktime
au FileChangedShell * echo "Warning: File changed on disk"
" match功能可以去match html tags
source /usr/share/vim/vim74/macros/matchit.vim
" nerdtree相關
"autocmd vimenter * if !argc() | NERDTree | endif
map <F2> :NERDTreeToggle<CR>
" taglist
map <F3> :TlistToggle<CR>
" pastetoggle
nnoremap <F9> :set invpaste paste?<CR>
set pastetoggle=<F9>
set showmode
" autocomplpop 顏色
highlight Pmenu term=reverse ctermbg=cyan ctermfg=black
highlight PmenuSel term=reverse ctermbg=lightred ctermfg=black
" neocomplcache
let g:neocomplcache_enable_at_startup = 1
" gundo 繪製undo tree
nnoremap <F5> :GundoToggle<CR>
" 開啟buffer清單
nnoremap <F6> :BufExplorer<CR>
" 切換行號顯示
nnoremap <F8> :set nu!<CR>
" 更改screen title
let &titlestring = "vim " . expand("%:t") . ""
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm"
  set title
endif
autocmd BufEnter * let &titlestring = "vim " . expand("%:t") . ""
let &titleold = fnamemodify($SHELL, ":t")
" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" startify
"     autocmd VimEnter *
"                 \ if !argc() |
"                 \ Startify |
"                 \ NERDTree |
"                 \ execute "normal \<c-w>w" |
"                 \ endif
" END
