{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "audio";
  port = "8083";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "ghcr.io/advplyr/audiobookshelf";
    ports = [ "${port}:80" ];
    volumes = [
      "/data/audiobook/config:/config"
      "/data/audiobook/metadata:/metadata"
      "/data/audiobook/audiobooks:/audiobooks"
      "/data/audiobook/podcasts:/podcasts"
    ];
  };
}
