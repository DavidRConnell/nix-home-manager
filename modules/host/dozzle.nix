{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "dozzle";
  port = "8090";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = false;
    image = "amir20/dozzle";
    ports = [ "${port}:8080" ];
    volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
    environment = { DOZZLE_NO_ANALYTICS = "true"; };
  };
}
