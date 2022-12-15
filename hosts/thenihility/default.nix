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
  };

  system.stateVersion = "20.09";

  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    # firewall.allowedTCPPorts = [ 80 443 ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.fstrim.enable = true;

  sound.enable = true;
  hardware = { pulseaudio.enable = true; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.voidee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    initialPassword = "password";
  };

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
