username: imports:
{ pkgs, config, ... }:

{
  inherit imports;
  home = rec {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "20.09";
    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      RESTIC_PASSWORD_COMMAND = "${pkgs.pass}/bin/pass show restic/thenihility";
      XDG_DATA_HOME = homeDirectory + "/.local/share";
      XDG_CACHE_HOME = homeDirectory + "/.cache";
      XDG_CONFIG_HOME = homeDirectory + "/.config";
    };

    packages = (
      with pkgs;
      [
        alacritty
        (aspellWithDicts (
          dicts: with dicts; [
            en
            en-computers
            en-science
          ]
        ))
        binutils
        cachix
        caffeine-ng
        fd
        feh
        ffmpeg-full
        git
        killall
        lxqt.xdg-desktop-portal-lxqt
        man-pages
        man-pages-posix
        mpv
        nextcloud-client
        nvtopPackages.nvidia
        pandoc
        pinentry-curses
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
        visidata
        w3m
        wget
        wordnet
        xclip
        thunar
        yt-dlp
        zathura
        zip
        zoom-us
      ]
    );
  };

  programs.home-manager.enable = true;

  systemd.user.targets = {
    graphical-session-pre = {
      Unit = {
        Description = "Dummpy pre session";
        BindsTo = [ "graphical-session.target" ];
        Before = [ "graphical-session.target" ];
      };
    };

    tray = {
      # Needed for some services that require tray.
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
  };

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
    extraOptions = [
      "ignore-scrolling"
      "exclude-root"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = ''
          #TabsToolbar {
            visibility: collapse !important;
          }
        '';

        settings = {
          "browser.tabs.tabmanager.enabled" = false;
          "browser.tabs.loadInBackground" = false;
          "browser.tabs.inTitlebar" = 1;
          "browser.link.open_newwindow" = 2;
          "browser.link.open_newwindow.restriction" = 0;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };

    policies = {
      AIControls = {
        Default = "blocked";
      };
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPockets = false;
        SponsoredStories = false;
        Snippets = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = true;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      GenerativeAI.Enabled = false;
      HardwareAcceleration = true;
      Homepage.URL = "http://start.home";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      PromptForDownloadLocation = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnBoarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };
    };
  };

  systemd.user.sessionVariables = {
    # TEMP HACK while enchant can't find dictionaries.
    ASPELL_CONF = "dict-dir ${
      pkgs.aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
          en-science
        ]
      )
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
