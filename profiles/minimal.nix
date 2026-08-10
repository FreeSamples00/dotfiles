# Minimal profile — barebones POSIX (SSH servers, containers, rescue)
# Works on any Unix system with just a shell and basic tools
{pkgs, ...}: {
  imports = [
    ./base.nix
    ../nix/home/git.nix
    ../nix/home/vim.nix
    ../nix/home/bash.nix
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
}
