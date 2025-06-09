" T3 Chat's Slim Vanilla Vimrc - The AstroNvim Aesthetic
" Focus: Visuals and feel, not features. Maximally lightweight.

"==============================================================================
" => Core Aesthetics (The "Look and Feel")
"==============================================================================
set termguicolors           " Essential for modern 24-bit color themes
colorscheme pablo          " A solid, built-in dark theme

syntax on
set number                  " Show line numbers
set relativenumber          " Use relative numbers for easy vertical jumps
set cursorline              " Highlight the current line to maintain focus
set laststatus=0            " Completely hide the status bar for a clean look

" Put the current file name in the terminal's title bar instead of a status bar
set title
set titlestring=%f

"==============================================================================
" => Essential Editor Behavior
"==============================================================================
set nocompatible            " Use Vim defaults, not vi's
set backspace=indent,eol,start " Sensible backspace behavior
set hidden                  " Switch buffers without needing to save
set mouse=a                 " Enable the mouse

" Sensible indentation defaults
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Better searching
set incsearch               " Show search results as you type
set ignorecase              " Ignore case in searches
set smartcase               " But don't ignore case if you type an uppercase letter

"==============================================================================
" => Minimalist Key Mappings
"==============================================================================
let mapleader = " " " Use space as the leader key

" --- File Explorer (Built-in netrw) ---
" Open the file explorer in the current directory.
nnoremap <leader>e :Explore<CR>

