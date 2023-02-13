{ config, pkgs, ... }:

{
  imports = [ ../../modules/user/udiskie.nix ../../modules/user/shell.nix ];

  home = rec {
    username = "mercury";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [ htop yt-dlp parted git wget ];
    stateVersion = "22.11";
    sessionVariables = {
      XDG_DATA_HOME = homeDirectory + "/.local/share";
      XDG_CACHE_HOME = homeDirectory + "/.cache";
      XDG_CONFIG_HOME = homeDirectory + "/.config";
    };
  };

  programs.home-manager.enable = true;
}
