# Default profile — dev workstation (Linux or macOS)
# Imports minimal, adds neovim, nushell, starship, lazygit, btop, zellij, bat, etc.
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minimal.nix
    ../nix/home/starship.nix
    ../nix/home/lazygit.nix
    ../nix/home/neovim.nix
    ../nix/home/nushell.nix
    ../nix/home/bat.nix
    ../nix/home/btop.nix
    ../nix/home/zellij.nix
  ];

  # Font management — installs fonts to ~/Library/Fonts/HomeManager (macOS)
  # or ~/.local/share/fonts (Linux) via HM's fontconfig module
  fonts.fontconfig.enable = true;

  # Refresh font cache after deployment (avoids blank Nerd Font glyphs on macOS)
  home.activation.refreshFontCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if command -v fc-cache >/dev/null 2>&1; then
      fc-cache -rf
    fi
  '';

  home.packages = with pkgs; [
    # Editor + deps
    python3
    nodejs
    gcc
    go
    rustup
    stylua
    shellcheck
    jq
    pandoc
    shfmt
    lua-language-server
    taplo
    prettier

    # Shell tools
    just
    gh

    # Search / fs
    ripgrep
    fd
    fzf
    eza
    dust
    bat

    # TUI
    btop
    zellij

    # CLI tools
    jc
    nmap
    imagemagick
    pipx
    hugo
    catimg
    exiftool
    transmission_4
    llvm

    # Python tools
    python3Packages.pygments

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.space-mono
    sketchybar-app-font

    # Other
    glow
    hyperfine
    figlet
    uv
    pre-commit
  ];
}
