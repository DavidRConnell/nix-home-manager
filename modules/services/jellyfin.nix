{
  name,
  subdomain,
  users,
  port,
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
        hostPath = "/data/${subdomain}/lib";
        isReadOnly = false;
      };
      "/var/cache/${name}" = {
        hostPath = "/data/${subdomain}/cache";
        isReadOnly = false;
      };
      "/var/lib/${name}/data/youtube" = {
        hostPath = "/data/tubearchivist/media";
        isReadOnly = true;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users;

      services.jellyfin = {
        enable = true;
        user = name;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
        allowedUDPPorts = [
          1900
          7359
        ];
      };
    };
  };

  # Hardcoded in jellyfin
  networking.firewall = {
    allowedUDPPorts = [
      1900
      7359
    ];
  };
}
