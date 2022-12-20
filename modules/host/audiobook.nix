{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "audio";
  port = "8083";
  dataPath = "/data/audiobook";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "ghcr.io/advplyr/audiobookshelf";
    ports = [ "${port}:80" ];
    volumes = [
      "${dataPath}/config:/config"
      "${dataPath}/metadata:/metadata"
      "${dataPath}/audiobooks:/audiobooks"
      "${dataPath}/podcasts:/podcasts"
    ];
  };
}
