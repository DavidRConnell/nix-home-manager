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
        package = pkgs.nextcloud29;
        hostName = "${subdomain}.${tld}";
        home = "/var/lib/${name}";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        settings.default_phone_region = "US";
        maxUploadSize = "5G";
        configureRedis = true;
        phpOptions."maintenance_window_start" = 8;
        phpOptions."opcache.interned_strings_buffer" = 9;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
    };
  };
}
