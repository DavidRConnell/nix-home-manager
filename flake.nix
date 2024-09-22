{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-24.05";
    };

    nixpkgs-unstable = { url = "/home/voidee/clones/nixpkgs"; };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "master";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    emacs-lsp-booster = {
      type = "github";
      owner = "slotThe";
      repo = "emacs-lsp-booster-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkg-module.nixpkgs = {
        overlays = [
          inputs.emacs-overlay.overlay
          inputs.emacs-lsp-booster.overlays.default
          (final: prev: {
            anydesk = prev.anydesk.overrideAttrs (old: {
              version = "6.3.3";
              src = prev.fetchurl {
                urls = [
                  "https://download.anydesk.com/linux/${old.pname}-6.3.3-amd64.tar.gz"
                  "https://download.anydesk.com/linux/generic-linux/${old.pname}-6.3.3-amd64.tar.gz"
                ];
                hash = "sha256-uSotkFOpuC2a2sRTagY9KFx3F2VJmgrsn+dBa5ycdck=";
              };
            });
          })
        ];
        config.allowUnfreePredicate = pkg:
          builtins.elem (pkgs.lib.getName pkg) [ "anydesk" "zoom" "vagrant" ];
      };
      server-pkg-module.nixpkgs = {
        overlays = [ (import ./overlays/lib.nix) ];
      };

      nixosSystem = { host, users, pkgs, modules ? [ ], services ? [ ] }:
        let userConfigs = map (user: user.homeConfig) users;
        in pkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            host
            (import utils/addusers.nix users)
          ] ++ userConfigs ++ modules ++ (if (builtins.length services > 0) then
            ([ ./utils/serversetup.nix ] ++ map (service:
              if (builtins.hasAttr "disabled" service && service.disabled) then
                { }
              else
                (import ./utils/expandservice.nix service)) services)
          else
            [ ]);
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
      nixosConfigurations = {
        thevoidII = nixosSystem {
          pkgs = nixpkgs;
          host = ./hosts/thevoidII;
          users = [ voidee ];
          modules = [
            pkg-module
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
          ];
        };

        thenihility = nixosSystem {
          pkgs = nixpkgs;
          host = ./hosts/thenihility;
          users = [ voidee ];
          modules = [
            pkg-module
            ./modules/host/desktop.nix
            ./modules/host/nix.nix
            ./modules/host/firejail.nix
          ];
        };

        olympus = nixosSystem {
          pkgs = nixpkgs;
          host = ./hosts/olympus;
          users = [ mercury ];
          modules = [
            server-pkg-module
            ./modules/host/nix.nix
            ./modules/host/headless.nix
            ./modules/host/startpage.nix
            ./modules/host/audiobook.nix
            ./modules/host/metube.nix
            ./modules/host/pocket.nix
            ./modules/host/dozzle.nix
            ./modules/host/lubelog.nix
            ./modules/host/tubearchivist.nix
          ];

          services = [
            {
              name = "AdGuardHome";
              subdomain = "adguard";
              id = 1;
            }
            {
              name = "nextcloud";
              id = 2;
              port = 80;
            }
            {
              name = "jellyfin";
              id = 3;
              port = 8096;
            }
            {
              name = "kavita";
              subdomain = "books";
              id = 4;
            }
            {
              name = "kavita";
              subdomain = "comics";
              id = 5;
              allowedIps = [ "192.168.0.100" "192.168.0.103" "192.168.0.104" ];
            }
            {
              name = "gitea";
              id = 6;
            }
            {
              name = "searx";
              id = 7;
            }
          ];
        };

        connellnet = nixosSystem {
          pkgs = nixpkgs;
          host = ./hosts/connellnet;
          users = [ mercury ];
          modules = [
            pkg-module
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

        testvm = nixosSystem {
          pkgs = nixpkgs;
          host = ./hosts/vm;
          users = [ mercury ];
          modules = [ pkg-module ];
        };
      };

      packages."${system}".testvm =
        self.nixosConfigurations.testvm.config.system.build.vm;
    };
}
