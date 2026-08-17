# Security profile — security/forensics toolkit
# Imports default (dev workstation), adds pentesting and forensics tools
# Deploy with: just nix deploy security
{pkgs, ...}: {
  imports = [
    ./default.nix
  ];

  home.packages = with pkgs; [
    # Password cracking
    john

    # Secret scanning
    noseyparker
    trufflehog

    # Network security
    aircrack-ng

    # Utilities
    p7zip
  ];
}
