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
    vars = import ./variables.nix;
    system = vars.system;
    pkgs = nixpkgs.legacyPackages.${system};
    username = vars.username;
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    specialArgs = {
      inherit username homeDirectory;
    };
  in {
    # Standalone Home Manager profiles (packages only — configs managed by chezmoi)
    homeConfigurations = {
      "${username}-minimal" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [./profiles/minimal.nix];
      };

      "${username}-default" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [./profiles/default.nix];
      };

      "${username}-security" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [./profiles/security.nix];
      };
    };

    # nix-darwin configuration (macOS only — only builds when system is darwin)
    darwinConfigurations."${username}-mac" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit username homeDirectory;};
      modules = [
        ./darwin/system.nix
        ./darwin/brew.nix
        ./darwin/services.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
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
