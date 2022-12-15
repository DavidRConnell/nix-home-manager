{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-22.05";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ltex-ls = {
      type = "gitlab";
      owner = "davidrconnell";
      repo = "ltex-ls-flake";
      ref = "master";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ inputs.emacs-overlay.overlay inputs.ltex-ls.overlay ]
          ++ self.overlays;
        config.allowUnfreePredicate = pkg:
          builtins.elem (pkgs.lib.getName pkg) [ "anydesk" "zoom" ];
      };

      nixosSystem = { modules }:
        nixpkgs.lib.nixosSystem { inherit system modules; };
    in {
      supportedSystems = [ system ];

      overlays = [ ./overlays/stumpwm.nix ];

      nixosConfigurations = {
        thevoidII = nixosSystem {
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/thevoidII
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
            ./modules/host/nextdns.nix
          ];
        };

        thenihility = nixosSystem {
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/thenihility
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
            ./modules/host/nextdns.nix
          ];
        };

        # olympus = nixpkgs
      };

      homeConfigurations = let
        username = "voidee";
        homeDirectory = "/home/voidee";
        system = "x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        generateHome = home-manager.lib.homeManagerConfiguration;
        home = { pkgs, ... }: import ./users/voidee.nix { inherit pkgs; };
      in {
        default = generateHome {
          inherit system username homeDirectory extraSpecialArgs;
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          configuration = {
            imports = [ home ];
            inherit nixpkgs;
          };
        };
      };
    };
}
