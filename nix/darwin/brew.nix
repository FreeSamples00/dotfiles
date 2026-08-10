# nix-darwin Homebrew configuration
# Full Brewfile migration — declares all casks and formulae
# cleanup = "none" means manual brew installs are not removed
{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "none"; # don't remove manually installed packages
      autoUpdate = true;
      upgrade = false; # let user control upgrades
    };

    # ---- Taps ----
    taps = [
      "barutsrb/tap"
      "domcyrus/rustnet"
      "felixkratz/formulae"
      "homebrew-zathura/zathura"
      "homebrew/bundle"
      "jackielii/tap"
      "nikitabobko/tap"
      "oven-sh/bun"
      "philocalyst/tap"
      "protonpass/tap"
      "scarvalhojr/tap"
    ];

    # ---- Casks (GUI apps) ----
    casks = [
      "nikitabobko/tap/aerospace"
      "alcove"
      "apparency"
      "betterdisplay"
      "caffeine"
      "discord"
      "docker-desktop"
      "font-jetbrains-mono-nerd-font"
      "font-sketchybar-app-font"
      "font-space-mono-nerd-font"
      "ghostty"
      "helium-browser"
      "karabiner-elements"
      "mactex-no-gui"
      "obsidian"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "raspberry-pi-imager"
      "raycast"
      "shottr"
      "stremio"
      "vlc"
      "wireshark-app"
      "yubico-authenticator"
      "zen"
    ];

    # ---- Formulae (CLI tools NOT managed by Nix) ----
    # These are tools that are either not in nixpkgs, have complex deps,
    # or are security/forensics tools that don't belong in HM profiles.
    brews = [
      # Service-related (felixkratz tap)
      "felixkratz/formulae/sketchybar"
      "felixkratz/formulae/borders"

      # Still needed during migration
      "stow"

      # General tools
      "gh"
      "hugo"
      "mpv"
      "poppler"
      "pv"
      "pygments"
      "jc"
      "exif"
      "catimg"
      "lolcat"

      # Network tools
      "openssh"
      "telnet"
      "whois"
      "wireshark"
      "nmap"

      # Security/forensics tools
      "aircrack-ng"
      "hashcat"
      "ghidra"
      "john-jumbo"
      "ophcrack"
      "noseyparker"
      "trufflehog"
      "binwalk"
      "p7zip"
      "binutils"

      # Libraries/build tools
      "libfido2"
      "libxcrypt"
      "llvm"
      "imagemagick"
      "isync"

      # Other
      "transmission-cli"
      "pipx"

      # Tapped formulae
      "domcyrus/rustnet/rustnet"
      "philocalyst/tap/caligula"
      "protonpass/tap/pass-cli"
    ];

    # Note: cargo, npm, and go installs are NOT managed by nix-darwin.
    # They remain in their respective package managers:
    # cargo: cargo-update, ghgrab, metapac, nu-lint, nufmt, rusty-hook, tdf-viewer
    # npm: neovim, ocx, vercel
    # go: golang.org/dl/go1.27rc1
  };
}
