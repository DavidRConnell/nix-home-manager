{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-23.05";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "master";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    ltex-ls = {
      type = "gitlab";
      owner = "davidrconnell";
      repo = "ltex-ls-flake";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
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
          builtins.elem (pkgs.lib.getName pkg) [
            "anydesk"
            "zoom"
            "facetimehd-firmware"
          ];
      };

      nixosSystem = { host, users, modules }:
        let userConfigs = map (user: user.homeConfig) users;
        in nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            pkg-module
            home-manager.nixosModules.home-manager
            host
            (import utils/addusers.nix users)
          ] ++ userConfigs ++ modules;
        };

      user = { name, home, modules }:
        let
          importList = fname:
            let fpath = home + ("/" + fname);
            in (if (builtins.pathExists fpath) then (import fpath) else [ ]);
        in {
          inherit name home modules;
          groups = importList "groups.nix";
          authorizedKeysFiles = importList "authorizedKeys.nix";
          homeConfig = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${name}" = (import home name modules);
          };
        };
      voidee = user {
        name = "voidee";
        home = ./users/voidee;
        modules = [
          ./modules/user/shell.nix
          ./modules/user/emacs
          ./modules/user/gtk.nix
          ./modules/user/udiskie.nix
          ./modules/user/passwords.nix
          ./modules/user/flameshot.nix
        ];
      };
      mercury = user {
        name = "mercury";
        home = ./users/mercury;
        modules = [ ./modules/user/shell.nix ./modules/user/udiskie.nix ];
      };
    in {
      supportedSystems = [ system ];

      overlays = [ (import ./overlays/lib.nix) ];

      nixosConfigurations = {
        thevoidII = nixosSystem {
          host = ./hosts/thevoidII;
          users = [ voidee ];
          modules = [
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
          ];
        };

        thenihility = nixosSystem {
          host = ./hosts/thenihility;
          users = [ voidee ];
          modules = [
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
          ];
        };

        olympus = nixosSystem {
          host = ./hosts/olympus;
          users = [ mercury ];
          modules = [
            ./modules/host/nix.nix
            ./modules/host/headless.nix
            ./modules/host/reverse-proxy.nix
            ./modules/host/startpage.nix
            (import ./modules/host/adguard.nix "192.168.0.101")
            ./modules/host/nextcloud.nix
            ./modules/host/jellyfin.nix
            ./modules/host/audiobook.nix
            ./modules/host/metube.nix
            ./modules/host/gitea.nix
            ./modules/host/pocket.nix
            ./modules/host/dozzle.nix
            # ./modules/host/collabora.nix
            ./modules/host/kavita.nix
            # ./modules/host/fileflows.nix
            ./modules/host/librarian.nix
          ];
        };

        connellnet = nixosSystem {
          host = ./hosts/connellnet;
          users = [ mercury ];
          modules = [
            ./modules/host/nix.nix
            ./modules/host/headless.nix
            ./modules/host/reverse-proxy.nix
            ./modules/host/startpage.nix
            (import ./modules/host/adguard.nix "192.168.4.195")
            ./modules/host/nextcloud.nix
            ./modules/host/jellyfin.nix
            ./modules/host/recipes.nix
            ./modules/host/pocket.nix
            ./modules/host/dozzle.nix
            ./modules/host/paperless.nix
            ./modules/host/photos.nix
          ];
        };
      };
    };
}
