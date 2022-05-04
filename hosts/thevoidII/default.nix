{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix /etc/nixos/cachix.nix ];

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

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps";
    displayManager.lightdm.enable = true;
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
    facetimehd.enable = true;
  };

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
