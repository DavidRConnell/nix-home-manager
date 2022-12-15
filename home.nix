{ pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = rec {
    username = "voidee";
    homeDirectory = "/home/${username}";
    stateVersion = "20.09";
    sessionPath = [ "$HOME/bin" ];
    sessionVariables = {
      RESTIC_PASSWORD_COMMAND = "${pkgs.pass}/bin/pass show backup";
      XDG_DATA_HOME = homeDirectory + "/.local/share";
      XDG_CACHE_HOME = homeDirectory + "/.cache";
      XDG_CONFIG_HOME = homeDirectory + "/.config";
    };

  };

  imports = [
    ./modules/shell.nix
    ./modules/emacs
    ./modules/mail.nix
    ./modules/gtk.nix
  ];

  home.packages = (with pkgs; [
    alacritty
    anydesk
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    binutils
    cachix
    fd
    feh
    firefox
    git
    gitAndTools.pass-git-helper
    google-cloud-sdk
    killall
    krita
    libsForQt5.xdg-desktop-portal-kde
    man-pages
    man-pages-posix
    mpv
    neovim
    nushell
    pandoc
    pass
    pulseaudio-ctl
    qutebrowser
    rclone
    redshift
    restic
    ripgrep
    rsync
    sbcl
    scrot
    sdcv
    stow
    stumpish
    tmux
    udiskie
    unzip
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

  manual.manpages.enable = true;
  programs.info.enable = true;
  fonts.fontconfig.enable = true;

  systemd.user.targets.tray = {
    # Needed for some services that require tray.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  services.udiskie = {
    enable = true;
    notify = false;
  };

  services.unclutter = {
    enable = true;
    timeout = 3;
    extraOptions = [ "ignore-scrolling" "exclude-root" ];
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg.enable = true;

  # See: https://github.com/TLATER/dotfiles/blob/master/nixpkgs/configurations/xdg-settings.nix
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
