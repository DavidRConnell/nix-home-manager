{ name, subdomain, users, environment, port, hostAddress, localAddress }: {
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${subdomain}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users environment;

      services.wallabag = {
        enable = true;
        user = name;
        domain = "http://${subdomain}.home";
        settings = { fosuser_confirmation = false; };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
    };
  };
}
