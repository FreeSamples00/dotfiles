# macOS profile — macOS desktop with services
# Imports default, adds ghostty, aerospace, sketchybar, jankyborders, karabiner, opencode
# nix-darwin integration (services, Brewfile) added later
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
    libfido2
  ];

  # nix-darwin modules (system-level, added later):
  # - nix/darwin/brew.nix (casks + formulae)
  # - nix/darwin/services.nix (launchd agents)
  # - nix/darwin/system.nix (macOS settings)
}
