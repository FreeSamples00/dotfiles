# Home Manager module: AeroSpace window manager
# Raw source deployment (config is a single TOML file at ~/.aerospace.toml)

{ ... }:

{
  # AeroSpace config lives at ~/.aerospace.toml (not XDG)
  home.file.".aerospace.toml".source = ../../aerospace.pkd/dot-aerospace.toml;
}
