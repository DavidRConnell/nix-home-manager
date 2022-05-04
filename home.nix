{ pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "voidee";
    homeDirectory = "/home/voidee";
    stateVersion = "20.09";
  };

  imports = [ ./modules/shell.nix ./modules/emacs ./modules/mail.nix ];

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
    (st.overrideAttrs (oldAttrs: rec {
      patches = [
        # Invert cursor color and text color
        (fetchpatch {
          url = "https://st.suckless.org/patches/dynamic-cursor-color/st-dynamic-cursor-color-0.8.4.diff";
          sha256 = "1f4kpqzi4anl0cxmd1kb33xndzmwr0xp66m2vrsx5hknslygfhn9";
        })
        # Prevent extra window borders.
        (fetchpatch {
          url = "https://st.suckless.org/patches/anysize/st-anysize-0.8.4.diff";
          sha256 = "1w3fjj6i0f8bii5c6gszl5lji3hq8fkqrcpxgxkcd33qks8zfl9q";
        })
      ];
      # configFile = writeText "config.def.h" (builtins.readFile "/home/voidee/clones/st/config.h");
      configFile = writeText "config.def.h" (builtins.readFile "${fetchurl {
        url = "https://github.com/DavidRConnell/dotfiles_and_friends/tree/8d7f2e528f0b1f92ec38776aa9147df2771d2d07/st/config.h";
        sha256 = "11a50baaag1y9mb6xrnml1ryyamqi923c3xh4066r4qipplva2iq";
      }}");
      postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
    }))
    stow
    tmux
    unzip
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
    nix-direnv.enableFlakes = true;
  };

  programs.gpg.enable = true;

  systemd.user.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
  };
  xsession.numlock.enable = true;
}
