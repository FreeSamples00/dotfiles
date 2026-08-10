{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nixpkgs, ... }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "scc";
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";

    # Import colorscheme
    colors = import ./nix/colors.nix;
  in {
    homeConfigurations."${username}-test" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit colors; };
      modules = [
        ({ config, ... }: {
          home = { inherit username homeDirectory stateVersion; };
          programs.home-manager.enable = true;
        })
        ./nix/home/git.nix
        ./nix/home/starship.nix
        ./nix/home/lazygit.nix
      ];
    };
  };
}
