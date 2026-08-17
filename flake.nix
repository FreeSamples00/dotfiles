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
    username = "scc";
    homeDirectory = "/Users/${username}";
    colors = import ./nix/colors.nix;
  in {
    # Standalone Home Manager profiles
    homeConfigurations = {
      "${username}-minimal" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit colors username homeDirectory;};
        modules = [./profiles/minimal.nix];
      };

      "${username}-default" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit colors username homeDirectory;};
        modules = [./profiles/default.nix];
      };

      "${username}-security" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit colors username homeDirectory;};
        modules = [./profiles/security.nix];
      };
    };

    # nix-darwin configuration
    darwinConfigurations."${username}-mac" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit username homeDirectory;};
      modules = [
        ./nix/darwin/system.nix
        ./nix/darwin/brew.nix
        ./nix/darwin/services.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit colors username homeDirectory;};
          home-manager.users.${username} = {pkgs, ...}: {
            imports = [./profiles/macos.nix];
            home = {
              inherit username;
              homeDirectory = nixpkgs.lib.mkForce homeDirectory;
              stateVersion = "25.05";
            };
          };
        }
      ];
    };
  };
}
