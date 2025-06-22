{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "lubelog";
  port = "8080";
  dataPath = "/data/lubelog";
in {
  services.caddy.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "ghcr.io/hargata/lubelogger:latest";
      ports = [ "${port}:8080" ];
      volumes = [
        "${dataPath}/data:/App/data"
        "${dataPath}/config:/App/config"
        "${dataPath}/translations:/App/wwwroot/translations"
        "${dataPath}/documents:/App/wwwroot/documents"
        "${dataPath}/images:/App/wwwroot/images"
        "${dataPath}/temp:/App/wwwroot/temp"
        "${dataPath}/log:/App/log"
        "${dataPath}/keys:/root/.aspnet/DataProtection-Keys"
      ];
      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        MailConfig__EmailServer = "";
        MailConfig__EmailFrom = "";
        MailConfig__UseSSL = "false";
        MailConfig__Port = "587";
        MailConfig__Username = "";
        MailConfig__Password = "";
        LOGGING__LOGLEVEL__DEFAULT = "Error";
      };
    };
  };
}
