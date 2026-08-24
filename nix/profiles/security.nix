{pkgs, ...}: {
  imports = [ ./default.nix ];

  home.packages = with pkgs; [
    john noseyparker aircrack-ng pv lolcat mpv p7zip trufflehog
  ];
}
