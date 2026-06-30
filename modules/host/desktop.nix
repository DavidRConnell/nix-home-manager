{ ... }:

{
  services.xserver = {
    enable = true;
    xkb.variant = "dvorak";
    xkb.options = "ctrl:nocaps";
    displayManager.lightdm.enable = true;
    desktopManager.lxqt.enable = true;
    windowManager.stumpwm.enable = true;
  };
}
