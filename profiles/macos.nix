# macOS profile — macOS desktop with services
# Imports default, adds ghostty, aerospace, sketchybar, jankyborders, karabiner, opencode
# Requires nix-darwin (added later)
{pkgs, ...}: {
  imports = [
    ./default.nix
    # TODO: ../nix/home/ghostty.nix
    # TODO: ../nix/home/jankyborders.nix
    # TODO: ../nix/home/opencode.nix
  ];

  home.packages = with pkgs; [
    # macOS tools
    pngpaste
    ykman
    yubico-piv-tool
    libfido2
  ];

  # TODO: ghostty config (generated config + theme file)
  # TODO: aerospace config (raw source)
  # TODO: sketchybar config (raw source)
  # TODO: jankyborders config (generated bordersrc)
  # TODO: karabiner config (raw source)
  # TODO: opencode config (source-filter + generated jsonc)

  # nix-darwin modules (system-level, added later):
  # - nix/darwin/brew.nix (casks + formulae)
  # - nix/darwin/services.nix (launchd agents)
  # - nix/darwin/system.nix (macOS settings)
}
