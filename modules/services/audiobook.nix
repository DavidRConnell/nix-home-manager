{
  name,
  subdomain,
  users,
  port,
  hostAddress,
  localAddress,
}:
{

  services.nginx.virtualHosts."${subdomain}.home".locations."/" = {
    proxyWebsockets = true;
    proxyPass = "http://${localAddress}:${(builtins.toString port)}";
  };

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

      services.audiobookshelf = {
        enable = true;
        host = localAddress;
        user = name;
        group = name;
        dataDir = name;
        port = port;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
    };
  };
}
