{ pkgs, ... }: {
  system.stateVersion = "22.05";

  networking = {
    hostName = "test";
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 ];
    };
  };

  services.getty.autologinUser = "mercury";
  virtualisation.vmVariant.virtualisation = {
    graphics = false;
    memorySize = 2048;
    cores = 2;
  };
}
