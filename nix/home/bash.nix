# Home Manager module: Bash
# Raw source deployment (.bashrc + .hushlogin)
{...}: {
  home.file.".bashrc".source = ../../configs/bash/bashrc;
  home.file.".hushlogin".source = ../../configs/bash/hushlogin;
}
