{ ... }:

{
  services.nginx = {
    recommendedProxySettings = true;
    enable = true;
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp2s0";
    };
  };
}
