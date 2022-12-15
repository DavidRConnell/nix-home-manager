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
    feh
    git
    gitAndTools.pass-git-helper
    krita
    man-pages
    man-pages-posix
    neovim
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
    tmux
    unzip
    visidata
    w3m
    wget
    wordnet
    xclip
    zathura
    zip
    zoom-us
  ]);

  manual.manpages.enable = true;

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg.enable = true;

  systemd.user.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
  };
  xsession.numlock.enable = true;
}
