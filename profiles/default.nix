# Default profile — dev workstation (Linux or macOS)
# Imports minimal, adds neovim, nushell, starship, lazygit, btop, zellij, bat, etc.

{ pkgs, ... }:

{
  imports = [
    ./minimal.nix
    ../nix/home/starship.nix
    ../nix/home/lazygit.nix
    # TODO: ../nix/home/neovim.nix
    # TODO: ../nix/home/nushell.nix
  ];

  home.packages = with pkgs; [
    # Editor + deps
    neovim
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
    nushell
    carapace
    zoxide
    just

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

    # Other
    glow
    hyperfine
    figlet
    uv
    pre-commit
  ];

  # TODO: neovim config (source-filter + palette.lua)
  # TODO: nushell config (source-filter + colors.nu)
  # TODO: btop config (raw source)
  # TODO: zellij config (raw source)
  # TODO: bat + lesskey config (raw source + bat cache --build activation hook)
}
