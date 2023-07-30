{ pkgs, config, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "pocket";
  port = "8088";
  dataPath = "/data/wallabag";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers."${subdomain}" = {
    autoStart = true;
    image = "wallabag/wallabag:latest";
    ports = [ "8088:80" ];
    volumes = [
      "${dataPath}/data:/var/www/wallabag/data"
      "${dataPath}/images:/var/www/wallabag/web/assets/images"
    ];
    environment = {
      SYMFONY__ENV__DOMAIN_NAME = "http://${subdomain}.home";
      SYMFONY__ENV__FOSUSER_CONFIRMATION = "false";
      SYMFONY__ENV__SERVER_NAME = "Wallabag";
    };
    extraOptions = [ "--pull=always" ];
  };
}
