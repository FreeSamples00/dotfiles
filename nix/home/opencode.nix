# Home Manager module: Opencode
# Deploy entire opencode tree from configs/opencode/

{ config, lib, pkgs, ... }:

{
  xdg.configFile."opencode" = {
    source = ../../configs/opencode;
    recursive = true;
  };
}
