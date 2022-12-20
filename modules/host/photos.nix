{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "photos";
  port = "8092";
  dataPath = "/data/photoview";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  systemd.services = pkgs.lib.mkDockerBridge { inherit subdomain; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "viktorstrate/photoview:latest";
      ports = [ "${port}:80" ];
      volumes = [
        "${dataPath}/api_cache:/app/cache"
        "/data/nextcloud/data:/photos:ro"
      ];
      environment = {
        PHOTOVIEW_DATABASE_DRIVER = "mysql";
        PHOTOVIEW_MYSQL_URL =
          "photoview:password@tcp(${subdomain}-db)/photoview";
        PHOTOVIEW_LISTEN_IP = "127.0.0.1";
        PHOTOVIEW_LISTEN_PORT = "80";
        PHOTOVIEW_MEDIA_CACHE = "/app/cache";
      };
      dependsOn = [ "${subdomain}-db" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-db" = {
      autoStart = true;
      image = "mariadb:10.5";
      volumes = [ "${dataPath}/db:/var/lib/mysql" ];
      environment = {
        MYSQL_DATABASE = "photoview";
        MYSQL_USER = "photoview";
        MYSQL_PASSWORD = "password";
        MYSQL_RANDOM_ROOT_PASSWORD = "1";
      };
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };
  };
}
