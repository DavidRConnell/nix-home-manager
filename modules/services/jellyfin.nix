{ name, subdomain, users, environment, port, hostAddress, localAddress }: {
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${subdomain}" = {
        hostPath = "/data/${subdomain}/lib";
        isReadOnly = false;
      };
      "/var/cache/${subdomain}" = {
        hostPath = "/data/${subdomain}/cache";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users environment;

      services.jellyfin = {
        enable = true;
        user = name;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
        allowedUDPPorts = [ 1900 7359 ];
      };
    };
  };

  # Hardcoded in jellyfin
  networking.firewall = { allowedUDPPorts = [ 1900 7359 ]; };
}
