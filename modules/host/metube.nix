{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "metube";
  port = "8086";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "alexta69/metube:latest";
    ports = [ "${port}:8081" ];
    volumes = [
      "/data/metube/downloads:/downloads"
      "/data/metube/downloads/media:/downloads/media"
      "/data/metube/downloads/audio:/downloads/audio"
    ];
    environment = {
      DOWNLOAD_DIR = "/downloads/media";
      AUDIO_DOWNLOAD_DIR = "/downloads/audio";
    };
    extraOptions = [ "--pull=always" ];
  };
}
