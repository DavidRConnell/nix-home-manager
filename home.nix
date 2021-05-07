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
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    zsh
    redshift
    alacritty
    tmux
    vim
    zip
    unzip
    htop
    rsync
    ripgrep
    wget
    direnv
    fzf
    scrot
    zathura
    binutils
    w3m
    nixfmt
    sqlite

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeType = "x-scheme-handler/org-protocol";
    })
  ];

  # https://github.com/rasendubi/dotfiles#emacs
  programs = {
    emacs = {
      enable = true;
      package = import ./emacs.nix { inherit pkgs; };
    };
  };
  #     extraPackages = epkgs: with epkgs.melpaPackages; [
    #     ];
    #   };
    # };

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
