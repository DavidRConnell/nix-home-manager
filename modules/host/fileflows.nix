{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "fileflows";
  port = "9014";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "ghcr.io/revenz/fileflows:latest";
    ports = [ "${port}:5000" ];
    environment = { TempPathHost = "/tmp/fileflows"; };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "/data/fileflows/data:/app/Data"
      "/data/fileflows/logging:/app/Logs"
      "/tmp/fileflows:/temp"
      "/data/fileflows/media:/media"
      "/data/metube/downloads/audio:/media/audiobooks"
      "/data/metube/downloads/media:/media/videos"
    ];
    extraOptions = [ "--pull=always" ];
  };
}
