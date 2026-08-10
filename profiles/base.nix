# Shared base module — imported by all profiles
# Settings here apply to every profile (util, core, macos)

{ config, ... }:

{
  home = {
    username = "scc";
    homeDirectory = "/Users/scc";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  # Force XDG config to ~/.config/ (not ~/Library/Application Support/)
  xdg.enable = true;
  xdg.configHome = "${config.home.homeDirectory}/.config";
}
