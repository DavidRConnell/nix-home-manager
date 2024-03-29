# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./backup.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "connellnet";

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  powerManagement.powertop.enable = true;

  services.xserver.enable = false;

  users.users.mercury = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ ../../users/mercury/authorized_keys ];
  };

  environment.systemPackages = with pkgs; [ vim git ];

  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = { enable = true; };

  networking.firewall.allowedTCPPorts = [ 53 80 443 ];
  networking.firewall.allowedUDPPorts = [ 53 443 ];

  services.nginx.virtualHosts = {
    "music.home".location."/".proxyPass = "http://192.168.4.125:9000";
    "m2p.home".location."/".proxyPass = "http://192.168.4.125:80";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
