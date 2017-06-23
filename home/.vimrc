" rich's vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use my own color scheme, based off of 'desert.vim'
" colorscheme rich 

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set autoindent		" always set autoindenting on
set writebackup		" backup while we're working
set nobackup		" but delete it afterwards
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set title		" title xterm
set tw=72		" eight columns for card sorter :-)
set ts=4 sw=4

" act like emacs
set showmatch		" jump to matching paren, like emacs
set splitbelow          " open new windows below, like emacs
set wildmenu		" present possible completions
set expandtab		" use spaces instead of tabs, like emacs
set laststatus=2        " always show status line
 
" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" vimtip #2: edit file in same directory as current file
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Mutt-related bits
  au BufNewFile,BufRead /tmp/mutt*  set ai et tw=72

  au Syntax bml source $VIMRUNTIME/syntax/perl.vim

endif " has("autocmd")
