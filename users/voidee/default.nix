username: imports:
{ pkgs, ... }:

{
  inherit imports;
  home = rec {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "20.09";
    sessionPath = [ "$HOME/bin" "$HOME/.local/bin" ];
    sessionVariables = {
      RESTIC_PASSWORD_COMMAND = "${pkgs.pass}/bin/pass show restic/thenihility";
      XDG_DATA_HOME = homeDirectory + "/.local/share";
      XDG_CACHE_HOME = homeDirectory + "/.cache";
      XDG_CONFIG_HOME = homeDirectory + "/.config";
    };

    packages = (with pkgs; [
      alacritty
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      binutils
      cachix
      caffeine-ng
      fd
      feh
      firefox
      git
      killall
      krita
      libsForQt5.xdg-desktop-portal-kde
      man-pages
      man-pages-posix
      mpv
      nvtopPackages.nvidia
      nextcloud-client
      pandoc
      pinentry-curses
      poetry
      podman-compose
      qutebrowser
      rclone
      redshift
      restic
      ripgrep
      rsync
      rustdesk-flutter
      sbcl
      scrot
      sdcv
      spotify-player
      stow
      stumpish
      tmux
      tomb
      unzip
      uv
      vagrant
      visidata
      w3m
      wget
      wordnet
      xclip
      xfce.thunar
      yt-dlp
      zathura
      zip
      zoom-us
    ]);
  };

  programs.home-manager.enable = true;

  manual.manpages.enable = true;
  programs.info.enable = true;
  fonts.fontconfig.enable = true;

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  services.unclutter = {
    enable = true;
    timeout = 3;
    extraOptions = [ "ignore-scrolling" "exclude-root" ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600 * 24;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  systemd.user.sessionVariables = {
    # TEMP HACK while enchant can't find dictionaries.
    ASPELL_CONF = "dict-dir ${
        pkgs.aspellWithDicts (dicts: with dicts; [ en en-computers en-science ])
      }/lib/aspell";
  };

  xdg = {
    enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "image/jpeg" = [ "feh.desktop" ];
      "image/jpg" = [ "feh.desktop" ];
      "image/png" = [ "feh.desktop" ];
      "x-scheme-handler/org-protocol" = [ "org-protocol.desktop" ];
      "text/plain" = [ "emacsclient.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
    };
  };
  xsession.numlock.enable = true;
}
