{ pkgs, ... }:

{
  home.packages = [ pkgs.udiskie ];
  services.udiskie = {
    enable = true;
    notify = false;
  };

  systemd.user.targets.tray = {
    # Needed for some services that require tray.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-sessionpre.target" ];
    };
  };
}
