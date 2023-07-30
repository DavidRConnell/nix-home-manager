{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "start";
  port = "8081";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "pawelmalak/flame:latest";
    ports = [ "${port}:5005" ];
    volumes = [ "/data/flame/data:/app/data" ];
    environment = { PASSWORD = "password"; };
    extraOptions = [ "--pull=always" ];
  };
}
