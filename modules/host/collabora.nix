{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "collabora";
  port = "9000";
  datadir = "/data/${subdomain}";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "collabora/code:latest";
    ports = [ "${port}:9980" ];
    environment = { extra_params = "--o:ssl.enable=false"; };
    extraOptions = [ "--pull=always" ];
  };
}
