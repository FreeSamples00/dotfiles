# Home Manager module: Vim
# Raw source deployment (.vimrc + colorscheme)

{ ... }:

{
  # .vimrc
  home.file.".vimrc".source = ../../configs/vim/vimrc;

  # Colorscheme
  home.file.".vim/colors".source = ../../configs/vim/colors;
}
