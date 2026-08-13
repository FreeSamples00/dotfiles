# macOS profile — macOS desktop with services
# Imports default, adds ghostty, aerospace, sketchybar, jankyborders, karabiner, opencode
{pkgs, ...}: {
  imports = [
    ./default.nix
    ../nix/home/ghostty.nix
    ../nix/home/jankyborders.nix
    ../nix/home/aerospace.nix
    ../nix/home/karabiner.nix
    ../nix/home/opencode.nix
    ../nix/home/sketchybar.nix
  ];

  home.packages = with pkgs; [
    # macOS tools
    pngpaste
    yubikey-manager
    yubico-piv-tool
    opencode
    libfido2
  ];
}
