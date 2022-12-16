{ config, pkgs, ... }:

{
  imports = [ ../../modules/user/udiskie.nix ];

  home = rec {
    username = "mercury";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [ htop yt-dlp protonvpn-cli losslesscut-bin ];
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    enableSshSupport = true;
  };
}
