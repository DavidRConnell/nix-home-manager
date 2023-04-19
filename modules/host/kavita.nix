{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "comics";
  port = "9012";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "kizaing/kavita:latest";
    ports = [ "${port}:5000" ];
    volumes =
      [ "/data/kavita/data:/manga" "/data/kavita/config:/kavita/config" ];
    extraOptions = [ "--pull=always" ];
  };
}
