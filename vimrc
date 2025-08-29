" Minimal Vim config

syntax on " Syntax highlighting
filetype plugin indent on   " Filetype detection, plugin and indent rules.


" UI
set number
set relativenumber
set expandtab shiftwidth=4 tabstop=4
set showmatch
set termguicolors

" Convenience
set clipboard=unnamedplus " Use system clipboard

" File saving and undo
set undofile
set updatetime=300

" Filetype-specific settings
autocmd FileType javascript,typescript,tsx,jsx,html,css,scss,json,yaml,markdown " Use 2 spaces for web-related filetypes
      \ setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=4 tabstop=4 colorcolumn=88 " Python uses 4 spaces and a PEP8 guideline ruler at column 88

autocmd FileType make setlocal noexpandtab " Makefiles MUST use tabs (never spaces)


" NVIM Specific settings
if has('nvim')
  " If inside a Python virtual environment, point Neovim’s Python host to it
  if exists('$VIRTUAL_ENV')
    let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'
  endif
endif

" Backup/swap files
if isdirectory(expand('~/.vim')) " Put Vim’s swap/undo files in ~/.vim directories (tidier than littering project folders)
  set directory=~/.vim/swap//
  set undodir=~/.vim/undo//
endif



