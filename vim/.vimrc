" Vim configuration file "
"
" By: William
"

" enable mouse support "
set mouse=a

" Show the current mode
set showmode

" enable clipboard support
set clipboard=unnamed

" enable syntax "
syntax on

" Enhance command-line completion
set wildmenu

" Allow cursor keys in insert mode
set esckeys

" enable line numbers "
set number

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
set gdefault

" highlight current line "
set cursorline
:highlight Cursorline cterm=bold ctermbg=black

" enable highlight search pattern "
set hlsearch

" enable smartcase search sensitivity "
set ignorecase
set smartcase

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_

" Highlight dynamically as pattern is typed
set incsearch


" Indentation using spaces "
" tabstop:	width of tab character
" softtabstop:	fine tunes the amount of whitespace to be added
" shiftwidth:	determines the amount of whitespace to add in normal mode
" expandtab:	when on use space instead of tab
" textwidth:	text wrap width
" autoindent:	autoindent in new line
set tabstop	=4
set softtabstop	=4
set shiftwidth	=4
set textwidth	=79
set expandtab
set autoindent

" show the matching part of pairs [] {} and () "
set showmatch

" remove trailing whitespace from Python and Fortran files "
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.f90 :%s/\s\+$//e
autocmd BufWritePre *.f95 :%s/\s\+$//e
autocmd BufWritePre *.for :%s/\s\+$//e

" enable color themes "
if !has('gui_running')
	set t_Co=256
endif
" enable true colors support "
set termguicolors
" Vim colorscheme "

:set relativenumber
:set rnu

colorscheme desert

try 
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

"Keymap
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
inoremap kk <ESC>

"Line Number
hi LineNrAbove guifg=yellow ctermfg=yellow
hi LineNrBelow guifg=cyan ctermfg=green

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

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

set history=500
filetype plugin on
filetype indent on
set autoread
set lazyredraw
set magic
set showmatch

set regexpengine=0

set nobackup
set noswapfile
set nowb

set si
set ai
set wrap

" Status Line
"" statusline
set laststatus=2
set statusline=                          " left align
set statusline+=%2*\                     " blank char
set statusline+=%2*\%{StatuslineMode()}%2*\ 
set statusline+=%1*\ <
set statusline+=%1*\ %f                  " short filename
set statusline+=%1*\ >
set statusline+=%=                       " right align
set statusline+=%*
set statusline+=%3*\%h%m%r               " file flags (help, read-only, modified)
set statusline+=%3*\%.25F                " long filename (trimmed to 25 chars)
set statusline+=%3*\:
set statusline+=%3*\%l/%L\\|             " line count
set statusline+=%3*\%y                   " file type

hi User1 ctermbg=black ctermfg=grey guibg=black guifg=grey
hi User2 ctermbg=green ctermfg=black guibg=cyan guifg=black
hi User3 ctermbg=black ctermfg=grey guibg=black guifg=grey

"" statusline functions
function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        hi User2 ctermbg=green ctermfg=black guibg=cyan guifg=black
        return "NORMAL"
    elseif l:mode==?"v"
        hi User2 ctermbg=green ctermfg=black guibg=magenta guifg=black
        return "VISUAL"
    elseif l:mode==#"i"
        hi User2 ctermbg=green ctermfg=black guibg=orange guifg=black
        return "INSERT"
    elseif l:mode==#"R"
        hi User2 ctermbg=green ctermfg=black guibg=red guifg=black
        return "REPLACE"
    endif
    hi User2 ctermbg=green ctermfg=black guibg=yellow guifg=black
    return "EXTRA"
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    lcd %:p:h
    let l:gitrevparse=system("git rev-parse --abbrev-ref HEAD")
    lcd -
    if l:gitrevparse!~"fatal: not a git repository"
      let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
    endif
  endif
endfunction
