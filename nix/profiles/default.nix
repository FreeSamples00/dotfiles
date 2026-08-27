{pkgs, ...}: {
  imports = [ ./minimal.nix ];

  home.packages = with pkgs; [
    python3 nodejs gcc go rustup stylua shellcheck jq pandoc shfmt
    lua-language-server taplo prettier just gh ripgrep fd fzf eza dust bat
    btop zellij jc nmap imagemagick pipx hugo catimg exiftool transmission_4 llvm
    python3Packages.pygments delta
    nerd-fonts.jetbrains-mono nerd-fonts.space-mono sketchybar-app-font
    glow hyperfine figlet uv pre-commit
    starship zoxide carapace
  ];

  fonts.fontconfig.enable = true;
}
