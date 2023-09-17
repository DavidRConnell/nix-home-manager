{ name, subdomain, tld, users, environment, port, hostAddress, localAddress }: {

  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = false; # Attempt to stop host fingerprint from changing for ssh.
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${name}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users environment;

      services.gitea = {
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

    forwardPorts = [{
      containerPort = 22;
      hostPort = 2222;
      protocol = "tcp";
    }];
  };
}
