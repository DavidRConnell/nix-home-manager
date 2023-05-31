# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./backup.nix ./local-sites.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/sda";
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  networking = {
    hostName = "olympus";
    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
  };

  powerManagement.powertop.enable = true;

  services.xserver.enable = false;

  environment.systemPackages = with pkgs; [ vim git ];

  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1wHI+bkrCHgmxnrL0G4JKfZwDBwf0WYP+0zbPSOhhaeyfJGK9NkLKwbOkGEEtyFPsAL7vRnO4IGWf87N9h/lyfahspJ2Mgl21ijsRSbnEfwaf7xiW0IwQ4ensAqsKd1wJF/oSM2cQKTtK5tGQ9wJ7Sv5D2Nt7ITsgk3CvvaM46OMHbnm2gFjy4147IH62NK/E9EQ9MoxqfVN7C6fPvN9Ks0510+YH/ykF78BrTyy/WOjyKl1Fnfx4zcAI08fEK3ePEE+aNQqymsojYNj5ZXBYOqIy0tUrAXM7vYNgAhnDBBw17ySXf2HBjXUP3MiFlu70re0w84uiFYrN2oOCiZOtEACRjHZXaubxBtaIqmL4NI8tEgHhR3cQe3E1xQVi7X//c+Lk4aNbUhCFjrBJsH74/MEhZQ9TlhVc5VrzTzltI3SbPBJcBviDOVKy938/0blV6wdO72/3mSPSEp9q+eE9db4S43lsdRQw4zplljODWTeXIwE3hGUDu97/lpXJTd0= voidee@thenihility"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 53 80 443 ];
  networking.firewall.allowedUDPPorts = [ 53 443 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
