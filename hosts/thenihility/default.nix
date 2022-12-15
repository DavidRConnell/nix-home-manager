{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings = {
    substituters =
      [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services.nextdns = {
    enable = true;
    arguments = [ "-config" "41d196" "-cache-size=10MB" "-report-client-info" ];
  };

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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "anydesk" "zoom" ];

  services.fstrim.enable = true;
  fileSystems."/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };

  sound.enable = true;
  hardware = { pulseaudio.enable = true; };

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

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      librewolf = {
        executable = "${pkgs.librewolf}/bin/librewolf";
        profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
      };
    };
  };
}
