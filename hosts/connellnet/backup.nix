{ pkgs, ... }:

let
  mountpoint = "/backup";
  device = "/dev/disk/by-label/backup";
in {
  fileSystems."${mountpoint}" = {
    device = "${device}";
    fsType = "ext4";
    options = [ "x-systemd.automount" ];
  };

  services.restic.backups.local = {
    paths = [ "/data" ];
    repository = "${mountpoint}/connellnet";
    passwordFile = "/etc/nixos/restic-password";
    initialize = true;
    timerConfig = {
      OnBootSec = "20m";
      OnCalendar = "daily";
    };
  };
}
