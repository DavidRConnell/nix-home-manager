{ pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = rec {
    username = "voidee";
    homeDirectory = "/home/${username}";
    stateVersion = "20.09";
    sessionPath = [ "$HOME/bin" ];
    sessionVariables = {
      RESTIC_PASSWORD_COMMAND = "${pkgs.pass}/bin/pass show restic/thenihility";
      XDG_DATA_HOME = homeDirectory + "/.local/share";
      XDG_CACHE_HOME = homeDirectory + "/.cache";
      XDG_CONFIG_HOME = homeDirectory + "/.config";
    };

  };

  imports = [
    ../modules/user/shell.nix
    ../modules/user/emacs
    # ../modules/user/mail.nix
    ../modules/user/gtk.nix
    ../modules/user/udiskie.nix
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
    nextcloud-client
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
