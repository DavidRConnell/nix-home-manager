{ ... }:

let mountpoint = "/backup";
in {
  fileSystems."${mountpoint}" = {
    device = "/dev/disk/by-label/backup";
    fsType = "ext4";
    options = [ "x-systemd.automount" "noauto" ];
  };

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
