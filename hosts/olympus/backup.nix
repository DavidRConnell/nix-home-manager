{ ... }:

let
  mountpoint = "/backup";
  device = "/dev/disk/by-label/backup";
in {
  fileSystems."${mountpoint}" = {
    device = "${device}";
    fsType = "ext4";
    options = [ "x-systemd.automount" "noauto" ];
  };

  services.restic.backups.local = {
    paths = [ "/data" ];
    repository = "${mountpoint}/olympus";
    passwordFile = "/etc/nixos/restic-password";
    initialize = true;
    # NOTE: Added in restic v0.15; nixpkgs on 0.14. Reenable when package bumped.
    # extraBackupArgs = [ "--no-scan" ]; # Can't see progress anyway
    timerConfig = { OnCalendar = "06:00"; };
  };
}
