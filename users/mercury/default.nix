username: imports:
{ pkgs, ... }:

{
  inherit imports;

  home = rec {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionPath = [ "$HOME/bin" ];
    packages = with pkgs; [ htop yt-dlp parted git wget zip unzip ];
    stateVersion = "22.11";
    sessionVariables = {
      XDG_DATA_HOME = homeDirectory + "/.local/share";
      XDG_CACHE_HOME = homeDirectory + "/.cache";
      XDG_CONFIG_HOME = homeDirectory + "/.config";
    };
  };

  programs.home-manager.enable = true;
}
