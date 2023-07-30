{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "librarian";
  port = "9015";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "cgrima/i-librarian:latest";
    ports = [ "${port}:80" ];
    volumes =
      [ "/data/ilibrarian/data:/app/data" "/etc/localtime:/etc/localtime:ro" ];
    extraOptions = [ "--pull=always" ];
  };
}
