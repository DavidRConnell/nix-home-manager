{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "podcasts";
  port = "8093";
  dataPath = "/data/podify";
  env = {
    URL_HOST = "http://${subdomain}.home";
    DATABASE_URL = "postgres://podify:password@${subdomain}-db/podify";
    REDIS_URL = "redis://${subdomain}-redis";
    SECRET_KEY_BASE =
      "a57d57661ef5df58b46fab6f04304e89108f22f89b31d2242b31891102da87d519a1f3c6459c1d2716b3b8c5438ef43e06ed4c29c8fb059eb650dc2ec0062d57";
    RAILS_LOG_TO_STDOUT = "yes";
    STORAGE_DIR = "/storage";
    INITIAL_USER_EMAIL = "you@example.com";
    INITIAL_USER_PASSWORD = "password";
    ENABLE_SIGNUP = "no";
  };
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  systemd.services = pkgs.lib.mkDockerBridge { inherit subdomain; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "maxhollmann/podify:latest";
      entrypoint = "start-server";
      ports = [ "${port}:3000" ];
      volumes = [ "${dataPath}/data:/storage" ];
      environment = env;
      dependsOn = [ "${subdomain}-redis" "${subdomain}-db" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-worker" = {
      autoStart = true;
      image = "maxhollmann/podify:latest";
      entrypoint = "start-worker";
      volumes = [ "${dataPath}/data:/storage" ];
      environment = env;
      dependsOn = [ "${subdomain}-redis" "${subdomain}-db" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-db" = {
      autoStart = true;
      image = "postgres:12.3";
      volumes = [ "${dataPath}/db:/var/lib/postgresql/data/pgdata" ];
      environment = {
        POSTGRES_USER = "podify";
        POSTGRES_PASSWORD = "password";
        PGDATA = "/var/lib/postgresql/data/pgdata";
      };
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-redis" = {
      autoStart = true;
      image = "docker.io/library/redis:6";
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };
  };
}
