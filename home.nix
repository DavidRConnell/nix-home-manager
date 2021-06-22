{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "voidee";
  home.homeDirectory = "/home/voidee";

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  home.packages = (with pkgs; [
    alacritty
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    binutils
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
    midori
    rsync
    scrot
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

  # https://github.com/rasendubi/dotfiles#emacs
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
    enableNixDirenvIntegration = true;
  };

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
