{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix /etc/nixos/cachix.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "20.09";

  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.stumpwm.enable = true;
    # windowManager.stumpwm.command = ''
    #   ${pkgs.local.stumpwm}/bin/stumpwm-lisp-launcher.sh \
    #   --eval '(require :asdf)' \
    #   --eval '(asdf:load-system :stumpwm)' \
    #   --eval '(stumpwm:stumpwm)'
    # '';
  };


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "zoom"
  ];

  services.fstrim.enable = true;

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.voidee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    initialPassword = "password";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
