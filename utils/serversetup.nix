{ ... }:

{
  services.nginx = {
    recommendedProxySettings = true;
    enable = true;
    clientMaxBodySize = "5G";
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp2s0";
    };

    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 443 ];
    };
  };
}
