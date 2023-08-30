{ name, subdomain, tld, users, port }: {
  containers."${subdomain}" = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = false;

    bindMounts = {
      "/var/lib/${name}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users;

      environment.systemPackages = with pkgs; [ dig ];
      services."${name}" = {
        enable = true;
        user = name;
        group = name;
        stateDir = "/var/lib/${name}";
        # Largerly taken from https://docs.pi-hole.net/guides/dns/unbound/
        settings.server = {
          inherit port;
          interface = [ "127.0.0.1" ];
          do-ip4 = true;
          do-ip6 = false;
          prefer-ip6 = false;
          do-udp = true;
          do-tcp = true;
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          edns-buffer-size = 1232;
          prefetch = true;
          num-threads = 1;
          logfile = "/var/lib/${name}/unbound.log";
          log-time-ascii = true;
          verbosity = 0;
          private-address = [
            "192.168.0.0/16"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "10.0.0.0/8"
            "fd00::/8"
            "fe80::/10"
          ];
        };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
        allowedUDPPorts = [ port ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };

}
