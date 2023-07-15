{ pkgs, ... }: {
  system.stateVersion = "22.05";

  networking = {
    hostName = "test";
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
  };

  virtualisation.vmVariant.virtualisation.graphics = false;
}
