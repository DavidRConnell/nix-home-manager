{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.11";
    };

    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "master";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable { inherit system; };
      pkg-module.nixpkgs = {
        overlays = [
          inputs.emacs-overlay.overlay
          (final: prev: {
            spotify-player = unstable.spotify-player;
            uv = unstable.uv;
            poetry = unstable.poetry;
            qutebrowser = unstable.qutebrowser;
            redlib = unstable.redlib;
          })
        ];

        config.allowUnfreePredicate = pkg:
          builtins.elem (pkgs.lib.getName pkg) [
            "zoom"
            "aspell-dict-en-science"
            "nvidia-x11"
            "cuda-merged"
            "cuda_cuobjdump"
            "cuda_gdb"
            "cuda_nvcc"
            "cuda_nvdisasm"
            "cuda_nvprune"
            "cuda_cccl"
            "cuda_cudart"
            "cuda_cupti"
            "cuda_cuxxfilt"
            "cuda_nvml_dev"
            "cuda_nvrtc"
            "cuda_nvtx"
            "cuda_profiler_api"
            "cuda_sanitizer_api"
            "libcublas"
            "libcufft"
            "libcurand"
            "libcusolver"
            "libnvjitlink"
            "libcusparse"
            "libnpp"
            "nvidia-settings"
          ];
      };

      server-pkg-module.nixpkgs = {
        overlays = [
          (import ./overlays/lib.nix)
          (final: prev: {
            searxng = unstable.searxng;
            websurfx = unstable.websurfx;
          })
        ];
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
            ./modules/host/habittrove.nix
            ./modules/host/tubearchivist.nix
            # ./modules/host/wger.nix
            # ./modules/host/calibreweb.nix
            # ./modules/host/actual.nix
            # ./modules/host/lubelog.nix
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
              tls = true;
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
              package = unstable.searxng;
            }
            {
              name = "redlib";
              id = 8;
              tls = true;
            }
            {
              name = "matrix";
              id = 9;
            }
            # {
            #   name = "invidious";
            #   id = 9;
            #   tls = true;
            # }

            # {
            #   name = "seafile";
            #   id = 10;
            #   port = 443;
            # }
            {
              name = "navidrome";
              id = 11;
              tls = true;
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
