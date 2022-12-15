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

    # Consider removing and using normal methods.
    utils = {
      type = "github";
      owner = "gytis-ivaskevicius";
      repo = "flake-utils-plus";
      ref = "master";
    };

    nixos-hardware = {
      type = "github";
      owner = "nixos";
      repo = "nixos-hardware";
      ref = "master";
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

  outputs = { self, nixpkgs, utils, home-manager, ... }@inputs:
    let system = "x86_64-linux";
    in utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ system ];

      channelsConfig.allowUnfree = true;

      hosts.thevoidII.modules =
        [ home-manager.nixosModules.home-manager ./hosts/thevoidII ];

      hosts.thenihility.modules =
        [ home-manager.nixosModules.home-manager ./hosts/thenihility ];

      homeConfigurations = let
        username = "voidee";
        homeDirectory = "/home/voidee";
        system = "x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        generateHome = home-manager.lib.homeManagerConfiguration;
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays =
          [ inputs.emacs-overlay.overlay inputs.ltex-ls.overlay ];
        home = { pkgs, ... }: import ./home.nix { inherit pkgs; };
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
