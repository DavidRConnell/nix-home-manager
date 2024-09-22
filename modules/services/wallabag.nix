{ name, subdomain, tld, users, environment, port, hostAddress, localAddress }: {
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${name}" = {
        hostPath = "/data/${subdomain}_test";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users environment;

      services.wallabag = {
        inherit port;
        enable = true;
        user = name;
        group = name;
        hostName = "${subdomain}.${tld}";
        stateDir = "/var/lib/${name}";
        database.type = "mysql";
        redis.enable = true;
        settings = {
          fosuser_confirmation = false;
          twofactor_auth = false;
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
