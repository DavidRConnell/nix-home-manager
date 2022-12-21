{ pkgs, ... }:

let
  mountpoint = "/backup";
  device = "/dev/disk/by-label/backup";
in {
  fileSystems."${mountpoint}" = {
    device = "${device}";
    fsType = "ext4";
    options = [ "x-systemd.automount" "noauto" ];
  };

  # 241 means 30 min for some reason (see man hdparm).
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 241 ${device};
  '';

  # Drive does not power down when the server does otherwise.
  powerManagement.powerDownCommands = ''
    ${pkgs.udiskie}/bin/udiskie-umount ${device} --detach
  '';

  services.restic.backups.local = {
    paths = [ "/data" ];
    repository = "${mountpoint}/olympus";
    passwordFile = "/etc/nixos/restic-password";
    initialize = true;
    timerConfig = {
      OnBootSec = "20m";
      OnCalendar = "daily";
    };
  };
}
