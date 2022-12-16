{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-22.11";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-22.11";
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
      pkgs = nixpkgs.legacyPackages.${system};
      pkg-module.nixpkgs = {
        overlays = [ inputs.emacs-overlay.overlay inputs.ltex-ls.overlay ]
          ++ self.overlays;
        config.allowUnfreePredicate = pkg:
          builtins.elem (pkgs.lib.getName pkg) [ "anydesk" "zoom" ];
      };

      nixosSystem = { modules, users }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ pkg-module home-manager.nixosModules.home-manager ]
            ++ users ++ modules;
        };

      user = { name, home }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${name}" = import home;
      };
      voidee = user {
        name = "voidee";
        home = ./users/voidee.nix;
      };
      mercury = user {
        name = "mercury";
        home = ./users/mercury;
      };
    in {
      supportedSystems = [ system ];

      overlays = [ ];

      nixosConfigurations = {
        thevoidII = nixosSystem {
          users = [ voidee ];
          modules = [
            ./hosts/thevoidII
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
            ./modules/host/nextdns.nix
          ];
        };

        thenihility = nixosSystem {
          users = [ voidee ];
          modules = [
            ./hosts/thenihility
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
            ./modules/host/nextdns.nix
          ];
        };

        olympus = nixosSystem {
          users = [ mercury ];
          modules = [
            ./hosts/olympus
            ./modules/host/nix.nix
            ./modules/host/headless.nix
          ];
        };
      };
    };
}
