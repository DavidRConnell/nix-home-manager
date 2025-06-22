{ name, subdomain, tld, users, environment, hostAddress, localAddress }: {
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${name}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users environment;

      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud31;
        hostName = "${subdomain}.${tld}";
        home = "/var/lib/${name}";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        settings.default_phone_region = "US";
        settings.trusted_proxies = [ "127.0.0.1" ];
        maxUploadSize = "5G";
        configureRedis = true;
        phpOptions."maintenance_window_start" = 8;
        phpOptions."opcache.interned_strings_buffer" = 9;
        config = {
          dbtype = "sqlite";
          dbname = "nextcloud";
        };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
    };
  };
}
