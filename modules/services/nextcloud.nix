{
  name,
  subdomain,
  tld,
  users,
  hostAddress,
  localAddress,
}:
{
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${name}" = {
        hostPath = "/data/${subdomain}/nextcloud";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users;

      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud33;
        hostName = "${subdomain}.${tld}";
        https = true;
        home = "/var/lib/${name}";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        maxUploadSize = "5G";
        configureRedis = true;

        settings = {
          default_phone_region = "US";
          trusted_proxies = [
            "127.0.0.1"
            "${hostAddress}"
          ];
          maintenance_window_start = 8;
        };

        phpOptions = {
          "opcache.interned_strings_buffer" = "16";
          "opcache.max_accelerated_files" = "10000";
          "opcache.memory_consumption" = "128";
          "opcache.save_comments" = "1";
          "opcache.revalidate_freq" = "1";
        };

        config = {
          dbtype = "sqlite";
          dbname = "nextcloud";
        };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          80
          443
        ];
      };
    };
  };
}
