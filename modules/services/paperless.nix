{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "paperless";
  port = "8095";
  dataPath = "/data/paperless";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  systemd.services = pkgs.lib.mkDockerBridge { inherit subdomain; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
      ports = [ "${port}:8000" ];
      volumes = [
        "${dataPath}/data:/usr/src/paperless/data"
        "${dataPath}/media:/usr/src/paperless/media"
        "${dataPath}/export:/usr/src/paperless/export"
        "${dataPath}/consume:/usr/src/paperless/consume"
        "${dataPath}/trash:/usr/src/paperless/trash"
      ];
      environment = {
        PAPERLESS_URL = "http://${subdomain}.home";
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_REDIS = "redis://${subdomain}-redis:6379";
        PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
        PAPERLESS_ADMIN_USER = "admin";
        PAPERLESS_ADMIN_PASSWORD = "password";
        PAPERLESS_TRASH_DIR = "/usr/src/paperless/trash";
      };
      dependsOn = [ "${subdomain}-redis" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-redis" = {
      autoStart = true;
      image = "docker.io/library/redis:7";
      volumes = [ "${dataPath}/redisdata:/data" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };
  };
}
