# Home Manager module: Jankyborders (window borders)
# Generated bordersrc with ARGB colors from nix/colors.nix
{colors, ...}: let
  to0x = colors.with0x;
in {
  xdg.configFile."borders/bordersrc".text = ''
    #!/bin/bash

    options=(
      style=round
      width=5.0
      hidpi=off
      active_color=${to0x colors.accent.dimmed.purple}
      inactive_color=${to0x colors.structural.surface}
    )

    borders "''${options[@]}"
  '';
}
