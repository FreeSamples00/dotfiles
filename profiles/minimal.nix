# Minimal profile — barebones POSIX (SSH servers, containers, rescue)
# Works on any Unix system with just a shell and basic tools

{ config, pkgs, username, homeDirectory, ... }:

{
  # ---- Shared base (inlined from former base.nix) ----
  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  # Force XDG config to ~/.config/ (not ~/Library/Application Support/)
  xdg.enable = true;
  xdg.configHome = "${config.home.homeDirectory}/.config";

  # ---- Minimal packages ----
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
    openssh
  ];

  # ---- Config modules ----
  imports = [
    ../nix/home/git.nix
    ../nix/home/vim.nix
    ../nix/home/bash.nix
  ];
}
