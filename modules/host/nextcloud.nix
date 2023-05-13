{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    hostName = "nextcloud.home";
    home = "/data/nextcloud";
    config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
    enableBrokenCiphersForSSE = false;
  };
}
