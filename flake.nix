{
  description = "NixOs configuration using flakes and home manager";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOs/nixpkgs/nixos-21.05";
    home-manager = {
      url =  "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/";

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      flake = false;
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, utils, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channels = {
        unstable.inputs = inputs.nixpkgs;
        stable.inputs = inputs.nixpkgs-stable;
      };
      channelsConfig.allowUnfree = true;

      sharedModules = [
        utils.nixosModules.saneFlakeDefaults
      ];

      hosts.thevoidII.modules = [
        home-manager.nixosModules.home-manager
        ./hosts/thevoidII
      ];

      homeConfigurations =
        let
          username = "voidee";
          homeDirectory = "/home/voidee";
          system = "x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          generateHome = home-manager.lib.homeManagerConfiguration;
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
        in
          {
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
