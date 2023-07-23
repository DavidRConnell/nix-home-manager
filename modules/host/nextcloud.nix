{ ... }:
let
  subdomain = "nextcloud";
  ipAddress = "10.0.2.17";
  uid = 10000;
in {
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp2s0";
    };
  };

  users.users."${subdomain}" = {
    home = "/data/${subdomain}";
    createHome = true;
    isSystemUser = true;
    uid = uid;
    group = subdomain;
  };
  users.groups."${subdomain}" = { gid = uid; };

  services.nginx.virtualHosts."${subdomain}.home".locations."/".proxyPass =
    "http://${ipAddress}:80";

  containers."${subdomain}" = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "10.0.2.16";
    localAddress = ipAddress;

    bindMounts = {
      "/var/lib/${subdomain}" = {
        hostPath = "/data/${subdomain}";
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

      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        hostName = "${subdomain}.home";
        home = "/var/lib/${subdomain}";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        enableBrokenCiphersForSSE = false;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };

      # Manually configure nameserver. Using resolved inside the container seems to fail
      # currently
      environment.etc."resolv.conf".text = "nameserver 9.9.9.9";
    };
  };
}
