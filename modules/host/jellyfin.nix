{ pkgs, ... }:

let
  subdomain = "jellyfin";
  ipAddress = "10.0.2.21";
  uid = 10002;
in {
  users.users."${subdomain}" = {
    home = "/data/${subdomain}";
    createHome = true;
    isSystemUser = true;
    uid = uid;
    group = subdomain;
  };
  users.groups."${subdomain}" = { gid = uid; };

  services.nginx.virtualHosts."${subdomain}.home".locations."/".proxyPass =
    "http://${ipAddress}:8096";

  containers."${subdomain}" = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "10.0.2.20";
    localAddress = ipAddress;

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
      users.users."${subdomain}" = {
        home = "/var/lib/${subdomain}";
        createHome = true;
        isSystemUser = true;
        uid = uid;
        group = subdomain;
      };
      users.groups."${subdomain}" = { gid = uid; };

      services.jellyfin = {
        enable = true;
        user = subdomain;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 8096 ];
        allowedUDPPorts = [ 1900 7359 ];
      };

      # Manually configure nameserver. Using resolved inside the container seems to fail
      # currently
      environment.etc."resolv.conf".text = "nameserver 9.9.9.9";
    };
  };

  networking.firewall = { allowedUDPPorts = [ 1900 7359 ]; };
}
