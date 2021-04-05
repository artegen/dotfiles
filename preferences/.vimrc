" the next 3 lines must come first
filetype on
filetype plugin indent on
syntax on

" default file encoding to utf-8
set encoding=utf-8
set fileencoding=utf-8
" list of file encodings to be matched when opening
set fileencodings=utf-8,latin-2,latin-1

set number              " show line numbers
" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif

set wrap
set paste
" mark 80 column red
set colorcolumn=80
" Highlight current line
set cursorline
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" tab settings
set tabstop=2           " width that a <TAB> character displays as
set expandtab           " convert <TAB> key-presses to spaces
set shiftwidth=2        " number of spaces to use for each step of (auto)indent
set softtabstop=2       " backspace after pressing <TAB> will remove up to this many spaces
" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" search features
set ignorecase
set smartcase
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" autoindent new lines
set autoindent
" insert newlines in C-like languages
set smartindent

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

" https://github.com/romainl/flattened
colorscheme flattened_dark

" Show the current mode
" set showmode
" display lightline
set laststatus=2        " Always show status line
set noshowmode

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

if has("autocmd")
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
