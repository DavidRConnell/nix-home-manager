{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/sda";
    };
    enableContainers = false;
    kernelModules = [ "kvm-intel" ];
  };

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "20.09";

  fileSystems."/archives" = {
    device = "/dev/disk/by-uuid/d57cc7ab-089f-4d14-9429-f4dc3128be84";
    fsType = "ext4";
  };

  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  networking = {
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    hostName = "thenihility";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.fstrim.enable = true;

  sound.enable = true;
  hardware = { pulseaudio.enable = true; };

  fonts.fonts = with pkgs; [
    hack-font
    roboto-mono
    roboto
    noto-fonts
    liberation_ttf
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
