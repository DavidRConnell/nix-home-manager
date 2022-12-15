{ ... }:

{
  systemd.user.targets.tray = {
    # Needed for some services that require tray.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
      Shortcuts = {
        TYPE_COPY = "Y";
        TYPE_MOVE_DOWN = "J";
        TYPE_MOVE_LEFT = "H";
        TYPE_MOVE_RIGHT = "L";
        TYPE_MOVE_UP = "K";
        TYPE_RESIZE_DOWN = "Shift+J";
        TYPE_RESIZE_LEFT = "Shift+H";
        TYPE_RESIZE_RIGHT = "Shift+L";
        TYPE_RESIZE_UP = "Shift+K";
      };
    };
  };
}
