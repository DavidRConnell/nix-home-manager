{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "onlyoffice";
  port = "8099";
  datadir = "/data/${subdomain}";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "onlyoffice/documentserver:latest";
    ports = [ "${port}:80" ];
    volumes = [
      "${datadir}/logs:/var/log/onlyoffice"
      "${datadir}/lib:/var/lib/onlyoffice"
      "${datadir}/db:/var/lib/postgresql"
      "${datadir}/data:/var/www/onlyoffice/Date"
    ];
  };
}
