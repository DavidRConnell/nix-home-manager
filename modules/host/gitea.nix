{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "gitea";
  port = "8085";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "gitea/gitea:latest";
    ports = [ "${port}:3000" "2285:22" ];
    volumes = [
      "/data/gitea/data:/data"
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [ "--pull=always" ];
  };
}
