# Home Manager module: zellij
# Raw source deployment

{ ... }:

{
  xdg.configFile."zellij" = {
    source = ../../zellij.pkd/.config/zellij;
    recursive = true;
  };
}
