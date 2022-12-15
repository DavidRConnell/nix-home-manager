{ config, pkgs, ... }: {

  gtk = {
    enable = true;
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-recent-files-max-age=0
      '';
    };
    gtk3 = {
      extraConfig = {
        gtk-recent-files-max-age = 0;
        gtk-recent-files-limit = 0;
      };
    };
    gtk4 = { extraConfig = { gtk-recent-files-enabled = false; }; };
  };
}
