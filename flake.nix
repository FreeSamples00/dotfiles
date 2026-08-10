{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    home-manager,
    nixpkgs,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    colors = import ./nix/colors.nix;
    models = import ./nix/shared/models.nix;
  in {
    homeConfigurations = {
      "scc-minimal" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit colors models;};
        modules = [./profiles/minimal.nix];
      };

      "scc-default" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit colors models;};
        modules = [./profiles/default.nix];
      };

      "scc-macos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit colors models;};
        modules = [./profiles/macos.nix];
      };
    };
  };
}
