# Home Manager module: Vim
# Raw source deployment (.vimrc + colorscheme)

{ ... }:

{
  # .vimrc
  home.file.".vimrc".source = ../../vim.pkd/dot-vimrc;

  # Colorscheme
  home.file.".vim/colors".source = ../../vim.pkd/.vim/colors;
}
