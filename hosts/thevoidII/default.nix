{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  # home.packages = with pkgs; [
  #   local.stumpwm
  # ];

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps";
    # Enable Desktop Environment.
    displayManager.lightdm.enable = true;
    desktopManager.gnome3.enable = true;
    windowManager.stumpwm.enable = true;
    # windowManager.stumpwm.command = ''
    #   ${pkgs.local.stumpwm}/bin/stumpwm-lisp-launcher.sh \
    #   --eval '(require :asdf)' \
    #   --eval '(asdf:load-system :stumpwm)' \
    #   --eval '(stumpwm:stumpwm)'
    # '';
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.voidee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  fonts.fonts = with pkgs; [ hack-font roboto-mono ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
