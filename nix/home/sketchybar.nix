# Home Manager module: Sketchybar
# Raw source deployment (complex multi-file nushell config)
# Dependencies: nushell (programs.nushell), timeout (coreutils), sketchybar binary (Homebrew for now)

{ ... }:

{
  xdg.configFile."sketchybar" = {
    source = ../../sketchybar.pkd/.config/sketchybar;
    recursive = true;
  };
}
