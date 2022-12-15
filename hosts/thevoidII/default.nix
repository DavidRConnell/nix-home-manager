{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/sda";
  };
  system.stateVersion = "20.09";

  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps";
    displayManager.lightdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.stumpwm.enable = true;
  };

  services.fstrim.enable = true;

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    facetimehd.enable = true;
  };

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
}
