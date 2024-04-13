{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "librum";
  port = "8099";
  dataPath = "/data/librum";
in {
  services.nginx.virtualHosts = mkVHost { inherit subdomain port; };
  systemd.services = pkgs.lib.mkDockerBridge { inherit subdomain; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "ghcr.io/librum-reader/librum-server:latest";
      ports = [ "${port}:5000" ];
      volumes = [ "${dataPath}/librum:/var/lib/librum-server/librum_storage" ];
      environment = {
        JWTValidIssuer = "exampleIssuer";
        JWTKey = "exampleOfALongSecretToken";
        SMTPEndpoint = "smtp.example.com";
        SMTPUsername = "${subdomain}";
        SMTPPassword = "librum@librum.home";
        DBConnectionString =
          "Server=mariadb;port=3306;Database=${subdomain};Uid=librum;Pwd=mariadb";
        AdminEmail = "admin@librum.home";
        AdminPassword = "password";
      };
      dependsOn = [ "${subdomain}-db" ];
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };

    "${subdomain}-db" = {
      autoStart = true;
      image = "mariadb:latest";
      volumes = [ "${dataPath}/db:/var/lib/mysql" ];
      environment = {
        MARIADB_USER = "${subdomain}";
        MARIADB_PASSWORD = "mariadb";
        MARIADB_DATABASE = "${subdomain}";
        MARIADB_ROOT_PASSWORD = "mariadb";
      };
      extraOptions = [ "--network=${subdomain}-bridge" ];
    };
  };
}
