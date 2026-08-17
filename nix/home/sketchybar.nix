# Home Manager module: Sketchybar
# Raw source deployment (complex multi-file nushell config)
# Dependencies: nushell (programs.nushell), timeout (coreutils), sketchybar binary (Homebrew for now)

{ ... }:

{
  xdg.configFile."sketchybar" = {
    source = ../../configs/sketchybar;
    recursive = true;
  };
}
