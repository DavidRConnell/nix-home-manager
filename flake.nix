{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-21.11";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/";

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      flake = false;
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ltex-ls.url = "gitlab:davidrconnell/ltex-ls-flake";
  };

  outputs = { self, nixpkgs, utils, home-manager, ... }@inputs:
    let system = "x86_64-linux";
    in utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;

      hosts.thevoidII.modules =
        [ home-manager.nixosModules.home-manager ./hosts/thevoidII ];

      homeConfigurations = let
        username = "voidee";
        homeDirectory = "/home/voidee";
        system = "x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        generateHome = home-manager.lib.homeManagerConfiguration;
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays =
          [ inputs.emacs-overlay.overlay inputs.ltex-ls.overlay ];
      in {
        default = generateHome {
          inherit system username homeDirectory extraSpecialArgs;
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          configuration = {
            imports = [ ./home.nix ];
            inherit nixpkgs;
          };
        };
      };
    };
}
