" ==================== Colors ====================
set termguicolors          
colorscheme habamax          

" ==================== Settings ====================
syntax on
set number                  
set relativenumber          
set cursorline              
set laststatus=0            

set title
set titlestring=%f

set nocompatible          
set backspace=indent,eol,start
set hidden                
set mouse=a                

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

set incsearch               
set ignorecase              
set smartcase               

" ==================== Mappings ====================

" set leader key
let mapleader = " "

" open file vim explorer
nnoremap <leader>e :Explore<CR>

" Mappings from keymaps.lua (translated to Vimscript)
" Normal mode: Remap 'd' to delete without yanking (black-hole register)
nnoremap d "_d

" Visual mode: Remap 'd' to delete visual selection without yanking
vnoremap d "_d

" Visual mode: remap 'p' & 'P' to put replace text w/out yanking the replaced text
xnoremap p "_dP
xnoremap P "_dP

" --- Cursor Shape Configuration ---
" These settings send terminal escape codes to change the cursor shape.
" They are primarily for terminal Vim and may not apply to GUI Vim (like Neovide).
" Escape codes for cursor shapes (CSI Ps SP q):
"   Ps = 0 or 1: Blinking Block
"   Ps = 2: Steady Block
"   Ps = 3: Blinking Underline
"   Ps = 4: Steady Underline
"   Ps = 5: Blinking Bar (I-beam)
"   Ps = 6: Steady Bar (I-beam)

" Normal mode and exiting Insert/Replace/Visual mode: Block cursor
" \x1b[2 q sets a steady block cursor. Use \x1b[1 q for blinking block.
let &t_EI = "\x1b[2 q" " End Insert (back to Normal mode)
let &t_VE = "\x1b[2 q" " Visual mode Exit (back to Normal mode)
let &t_ER = "\x1b[2 q" " End Replace (back to Normal mode)

" Insert mode: Line cursor (vertical bar / I-beam)
" \x1b[5 q sets a blinking bar cursor. Use \x1b[6 q for steady bar.
let &t_SI = "\x1b[5 q" " Start Insert

" Replace mode: Underscore cursor
" \x1b[3 q sets a blinking underline cursor. Use \x1b[4 q for steady underline.
let &t_SR = "\x1b[3 q" " Start Replace
