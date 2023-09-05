{ name, subdomain, users, port, hostAddress, localAddress }: {
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
      "/etc/nixos/key.txt" = { hostPath = "/etc/nixos/keys/kavita-token.txt"; };
    };

    config = { config, pkgs, ... }: {
      inherit users;

      services."${name}" = {
        enable = true;
        user = name;
        dataDir = "/var/lib/${name}";
        port = port;
        tokenKeyFile = "/etc/nixos/key.txt";
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
    };
  };
}
