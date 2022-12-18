{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "adguard";
  port = "8080";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "adguard/adguardhome:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "${port}:80/tcp"
      "443:443/tcp"
      "443:443/udp"
      "3000:3000/tcp"
    ];
    volumes = [
      "/data/adguard/work:/opt/adguardhome/work"
      "/data/adguard/conf:/opt/adguardhome/conf"
    ];
  };
}
