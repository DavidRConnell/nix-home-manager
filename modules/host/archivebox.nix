{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "archivebox";
  port = "8094";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "archivebox/archivebox:master";
    cmd = [ "server --quick-init 0.0.0.0:8000" ];
    ports = [ "${port}:8000" ];
    volumes = [ "/data/${subdomain}:/data" ];
    environment = {
      ALLOWED_HOSTS = "archivebox.home";
      MEDIA_MAX_SIZE = "750m";
    };
  };
}
