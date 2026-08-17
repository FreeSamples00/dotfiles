# Home Manager module: Karabiner-Elements
# Raw source deployment
{...}: {
  xdg.configFile."karabiner" = {
    source = ../../configs/karabiner;
    recursive = true;
  };
}
