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
    colors = import ./nix/colors.nix;
  in {
    homeConfigurations = {
      "scc-util" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit colors; };
        modules = [ ./profiles/util.nix ];
      };

      "scc-core" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit colors; };
        modules = [ ./profiles/core.nix ];
      };

      "scc-macos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit colors; };
        modules = [ ./profiles/macos.nix ];
      };
    };
  };
}
