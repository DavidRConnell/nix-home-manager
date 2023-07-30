{ name, subdomain ? name, tld, users, hostAddress, localAddress }: {
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
      users = users;

      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        hostName = "${subdomain}.${tld}";
        home = "/var/lib/${subdomain}";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        enableBrokenCiphersForSSE = false;
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
    };
  };
}
