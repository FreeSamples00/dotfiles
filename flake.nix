{
  description = "Home Manager + nix-darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    home-manager,
    nix-darwin,
    nixpkgs,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    colors = import ./nix/colors.nix;
    models = import ./nix/shared/models.nix;
  in {
    # Standalone Home Manager profiles (for non-macOS or quick HM-only updates)
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
    };

    # nix-darwin configuration (macOS — services + Homebrew + HM macos profile)
    darwinConfigurations."scc-mac" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./nix/darwin/system.nix
        ./nix/darwin/brew.nix
        ./nix/darwin/services.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit colors models;};
          home-manager.users.scc = {pkgs, ...}: {
            imports = [./profiles/macos.nix];
            home = {
              username = "scc";
              homeDirectory = nixpkgs.lib.mkForce "/Users/scc";
              stateVersion = "25.05";
            };
          };
        }
      ];
    };
  };
}
