# Home Manager module: bat + lesskey
# Raw source deployment + bat cache --build activation hook

{ config, lib, pkgs, ... }:

{
  # bat config + custom theme
  xdg.configFile."bat/config".source = ../../pager.pkd/.config/bat/config;
  xdg.configFile."bat/themes/colorscheme.tmTheme".source = ../../pager.pkd/.config/bat/themes/colorscheme.tmTheme;

  # lesskey config
  xdg.configFile."lesskey".source = ../../pager.pkd/.config/lesskey;

  # Build bat cache after deployment so the custom theme is available
  home.activation.buildBatCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.bat}/bin/bat cache --build
  '';
}
