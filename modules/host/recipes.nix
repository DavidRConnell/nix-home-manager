{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "recipes";
  port = "8087";
  dataPath = "/data/tandoor";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  systemd.services = pkgs.lib.mkDockerBridge { inherit subdomain; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "vabene1111/recipes";
      ports = [ "${port}:8080" ];
      volumes = [
        "${dataPath}/staticfiles:/opt/recipes/staticfiles"
        "${dataPath}/mediafiles:/opt/recipes/mediafiles"
      ];
      environment = {
        SECRET_KEY = "password";
        DB_ENGINE = "django.db.backends.postgresql";
        POSTGRES_HOST = "${subdomain}-db";
        POSTGRES_PORT = "5432";
        POSTGRES_USER = "tandoor";
        POSTGRES_PASSWORD = "password";
        POSTGRES_DB = "${subdomain}-db";
      };
      dependsOn = [ "${subdomain}-db" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-db" = {
      autoStart = true;
      image = "postgres:11-alpine";
      volumes = [ "${dataPath}/db:/var/lib/postgresql/data" ];
      environment = {
        POSTGRES_USER = "tandoor";
        POSTGRES_PASSWORD = "password";
        POSTGRES_DB = "${subdomain}-db";
      };
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };
  };
}
