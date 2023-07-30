{ ... }:
let
  subdomain = "unbound";
  ipAddress = "10.0.2.19";
  uid = 10004;
in {
  users.users."${subdomain}" = {
    home = "/data/${subdomain}";
    createHome = true;
    isSystemUser = true;
    uid = uid;
    group = subdomain;
  };
  users.groups."${subdomain}" = { gid = uid; };

  containers."${subdomain}" = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "10.0.2.18";
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
