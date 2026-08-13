# Shared base module — imported by all profiles
# Settings here apply to every profile (minimal, default, macos)

{ config, username, homeDirectory, ... }:

{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  # Force XDG config to ~/.config/ (not ~/Library/Application Support/)
  xdg.enable = true;
  xdg.configHome = "${config.home.homeDirectory}/.config";
}
