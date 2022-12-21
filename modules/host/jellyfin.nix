{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "jellyfin";
  port = "8084";
  dataPath = "/data/jellyfin";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "jellyfin/jellyfin:latest";
    volumes = [
      "${dataPath}/config:/config"
      "${dataPath}/cache:/cache"
      "/var/log/jellyfin:/log"
      "${dataPath}/data:/media:ro"
    ];
    ports = [ "${port}:8096" ];
    environment = { JELLYFIN_LOG_DIR = "/log"; };
  };
}
