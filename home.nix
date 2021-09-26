{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "voidee";
    homeDirectory = "/home/voidee";
    stateVersion = "20.09";
  };

  home.packages = (with pkgs; [
    alacritty
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    binutils
    facetimehd-firmware
    feh
    fzf
    git
    htop
    neovim
    nixfmt
    pandoc
    pass
    qutebrowser
    rclone
    redshift
    restic
    ripgrep
    rsync
    sbcl
    scrot
    sdcv
    shfmt
    sqlite
    stow
    tectonic
    tmux
    tree
    unzip
    w3m
    wget
    wordnet
    zathura
    zip
    zsh

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeType = "x-scheme-handler/org-protocol";
    })
  ] ++
  [ gitAndTools.pass-git-helper ]
);

  programs.emacs = {
    enable = true;
    package = import ./emacs.nix { inherit pkgs; };
  };

  services.emacs.enable = true;

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
  };
}
