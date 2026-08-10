# Util profile — barebones POSIX (SSH servers, containers, rescue)
# Works on any Unix system with just a shell and basic tools

{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix/home/git.nix
  ];

  home.packages = with pkgs; [
    vim
    git
    bash
    coreutils
    curl
    wget
    tree
    less
    rsync
  ];

  # Vim config — raw source
  # TODO: vim raw source deployment (.vimrc → ~/.vimrc, colors/catppuccin.vim → ~/.vim/colors/)

  # Bash config — raw source
  # TODO: bash raw source deployment (.bashrc → ~/.bashrc)
}
