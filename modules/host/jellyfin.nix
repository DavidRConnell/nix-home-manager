{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "jellyfin";
  port = "8084";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "jellyfin/jellyfin:latest";
    volumes = [
      "/data/jellyfin/config:/config"
      "/data/jellyfin/cache:/cache"
      "/var/log/jellyfin:/log"
      "/data/jellyfin/data:/media:ro"
    ];
    ports = [ "${port}:8096" ];
    environment = { JELLYFIN_LOG_DIR = "/log"; };
  };
}
