{ config, pkgs, ... }:

{
  home = rec {
    username = "mercury";
    homeDirectory = "/home/${username}";
    packages = [ pkgs.htop pkgs.yt-dlp pkgs.protonvpn-cli ];
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    enableSshSupport = true;
  };
}
