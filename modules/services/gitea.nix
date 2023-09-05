{ name, subdomain, tld, users, port, hostAddress, localAddress }: {
  networking.nat.forwardPorts = [{
    sourcePort = 2222;
    proto = "tcp";
    destination = "${localAddress}:22";
  }];

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

      services."${name}" = {
        enable = true;
        user = name;
        group = name;
        stateDir = "/var/lib/${name}";
        settings.server = {
          DOMAIN = "${subdomain}.${tld}";
          HTTP_PORT = port;
          HTTP_ADDR = localAddress;
        };
        database = { user = name; };
      };

      system.stateVersion = "22.05";

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 22 port ];
      };
    };
  };
}
