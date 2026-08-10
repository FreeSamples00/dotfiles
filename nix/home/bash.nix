# Home Manager module: Bash
# Raw source deployment (.bashrc + .hushlogin)

{ ... }:

{
  home.file.".bashrc".source = ../../bash.pkd/dot-bashrc;
  home.file.".hushlogin".source = ../../bash.pkd/.hushlogin;
}
