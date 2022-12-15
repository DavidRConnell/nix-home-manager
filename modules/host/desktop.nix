{ ... }:

{
  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps";
    displayManager.lightdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.stumpwm.enable = true;
  };
}
