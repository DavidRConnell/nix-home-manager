{ pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "voidee";
    homeDirectory = "/home/voidee";
    stateVersion = "20.09";
  };

  imports = [ ./modules/shell.nix ./modules/emacs ./modules/mail.nix ];

  home.packages = (with pkgs;
    [
      alacritty
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      binutils
      facetimehd-firmware
      feh
      git
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
    ] ++ [ gitAndTools.pass-git-helper ]);

  manual.manpages.enable = true;

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };

  programs.gpg = {
    enable = true;
  };

  systemd.user.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
  };
}
