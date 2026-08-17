# Home Manager module: zellij
# Raw source deployment
{...}: {
  xdg.configFile."zellij" = {
    source = ../../configs/zellij;
    recursive = true;
  };
}
