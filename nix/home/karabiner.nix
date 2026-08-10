# Home Manager module: Karabiner-Elements
# Raw source deployment

{ ... }:

{
  xdg.configFile."karabiner" = {
    source = ../../karabiner.pkd/.config/karabiner;
    recursive = true;
  };
}
