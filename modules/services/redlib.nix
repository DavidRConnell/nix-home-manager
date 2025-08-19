{ name, subdomain ? name, users, uid, port, hostAddress, localAddress }: {
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
      inherit users;

      services.redlib = {
        enable = true;
        port = port;
        settings = {
          REDLIB_ROBOTS_DISABLE_INDEXING = true;
          REDLIB_DEFAULT_THEME = "default";
          REDLIB_DEFAULT_HIDE_AWARDS = true;
        };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };

    };
  };
}
