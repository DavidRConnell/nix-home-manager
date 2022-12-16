{ ... }:

{
  virtualisation.oci-containers.containers."jellyfin" = {
    autoStart = true;
    image = "jellyfin/jellyfin:latest";
    volumes = [
      "/data/jellyfin/config:/config"
      "/data/jellyfin/cache:/cache"
      "/var/log/jellyfin:/log"
      "/data/jellyfin/data:/media:ro"
    ];
    ports = [ "8084:8096" ];
    environment = { JELLYFIN_LOG_DIR = "/log"; };
  };
}
