# Default profile — dev workstation (Linux or macOS)
# Imports minimal, adds neovim, nushell, starship, lazygit, btop, zellij, bat, etc.
{pkgs, ...}: {
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

  # TODO: vim raw source deployment
  # TODO: bash raw source deployment
}
