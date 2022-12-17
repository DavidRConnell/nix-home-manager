{ config, pkgs, ... }:

{
  imports = [ ../../modules/user/udiskie.nix ];

  home = rec {
    username = "mercury";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [ htop yt-dlp losslesscut-bin ];
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;
}
