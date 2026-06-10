{ pkgs, config, ... }:

{
  imports = [ ./hardware-configuration.nix ./local_sites.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/sda";
    };
    enableContainers = false;
    kernelModules = [ "kvm-intel" ];
    tmp.cleanOnBoot = true;
  };

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "20.09";

  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems = {
    "/archives" = {
      device = "/dev/disk/by-uuid/d57cc7ab-089f-4d14-9429-f4dc3128be84";
      fsType = "ext4";
    };
    "/mnt/nfs" = {
      device = "olympus:/data";
      fsType = "sshfs";
      options = [ "nodev" "noatime" "allow_other" ];
    };
  };

  time.timeZone = "America/New_York";

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    hostName = "thenihility";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.fstrim.enable = true;

  # GPU
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.setupCommands = ''
      ${pkgs.xrandr}/bin/xrandr --output HDMI-1 --auto --output HDMI-1-0 --auto --right-of HDMI-1
    '';
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    nvidia-container-toolkit.enable = true;
  };

  security.pki.certificateFiles = [ ../../ca-certs/olympus.crt ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    hack-font
    roboto-mono
    roboto
    noto-fonts
    liberation_ttf
    dejavu_fonts
  ];

  programs.ssh.askPassword = "";
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
