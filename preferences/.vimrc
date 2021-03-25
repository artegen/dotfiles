" the basics
set encoding=utf-8      " set encoding to UTF-8, default is latin1
set number              " show line numbers
set wrap                " wrap lines
colorscheme ron         " colorscheme ron

" tab settings
set tabstop=2           " width that a <TAB> character displays as
set expandtab           " convert <TAB> key-presses to spaces
set shiftwidth=2        " number of spaces to use for each step of (auto)indent
set softtabstop=2       " backspace after pressing <TAB> will remove up to this many spaces
set autoindent          " auto indent for quality of life

" search features
set incsearch           " search as characters are entered
set hlsearch            " highlight matches


set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set paste
set smartindent
" case insensitive search
set ignorecase
set smartcase
" ask to save
set confirm
"set number
syntax on

""""""

call plug#begin('~/.vim/plugged')

" https://github.com/romainl/flattened
Plug 'romainl/flattened'

" https://github.com/itchyny/lightline.vim
Plug 'itchyny/lightline.vim'

" https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

" https://github.com/fatih/vim-go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" https://vimawesome.com/plugin/syntastic
Plug 'vim-syntastic/syntastic'

call plug#end()

""""""

" display lightline
set laststatus=2
set noshowmode

" https://github.com/romainl/flattened
colorscheme flattened_dark

" NERDTree opts
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>

" syntastic opts
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_go_checkers=['golint']
