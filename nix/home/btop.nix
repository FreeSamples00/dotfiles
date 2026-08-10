# Home Manager module: btop
# Raw source deployment

{ ... }:

{
  xdg.configFile."btop" = {
    source = ../../btop.pkd/.config/btop;
    recursive = true;
  };
}
