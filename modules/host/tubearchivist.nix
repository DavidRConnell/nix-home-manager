{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "tubearchivist";
  port = "8095";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  systemd.services = pkgs.lib.mkDockerBridge { inherit subdomain; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "bbilly1/tubearchivist";
      ports = [ "${port}:8000" ];
      volumes = [
        "/data/${subdomain}/media:/youtube"
        "/data/${subdomain}/cache:/cache"
      ];
      environment = {
        TA_HOST = "http://${subdomain}.home";
        TA_USERNAME = "voidee";
        TA_PASSWORD = "password";
        HOST_UID = "1000";
        HOST_GID = "100";
        ELASTIC_PASSWORD = "password";
        REDIS_CON = "redis://${subdomain}-redis";
        ES_URL = "http://${subdomain}-es:9200";
        TZ = "UTC";
      };
      dependsOn = [ "${subdomain}-redis" "${subdomain}-es" ];
      extraOptions = [ "--pull=always" "--network=${subdomain}-bridge" ];
    };
    "${subdomain}-redis" = {
      autoStart = true;
      image = "redis/redis-stack-server:6.2.6-v9";
      volumes = [ "/data/${subdomain}/redis:/data" ];
      dependsOn = [ "${subdomain}-es" ];
      extraOptions =
        [ "--pull=always" "--network=${subdomain}-bridge" "--expose=6379" ];
    };
    "${subdomain}-es" = {
      autoStart = true;
      image = "bbilly1/tubearchivist-es";
      environment = {
        ELASTIC_PASSWORD = "password";
        ES_JAVA_OPTS = "-Xms512m -Xmx512m";
        "xpack.security.enabled" = "true";
        "discovery.type" = "single-node";
        "path.repo" = "/usr/share/elasticsearch/data/snapshot";
        HOST_UID = "1000";
        HOST_GID = "100";
      };
      volumes =
        [ "/data/${subdomain}/elasticsearch:/usr/share/elasticsearch/data" ];
      extraOptions =
        [ "--pull=always" "--network=${subdomain}-bridge" "--expose=9200" ];
    };
  };
}
