{ config, lib, pkgs, ... }:

let
  cfg = config.services.xserver.windowManager.stumpwm-custom;
  sbcl = "${pkgs.sbcl}/bin/sbcl --script";
  alexandria = pkgs.lispPackages_new.build-asdf-system {
    pname = "alexandria";
    version = "v1.4";
    src = pkgs.fetchzip {
      url =
        "https://gitlab.common-lisp.net/alexandria/alexandria/-/archive/v1.4/alexandria-v1.4.tar.gz";
      sha256 = "0r1adhvf98h0104vq14q7y99h0hsa8wqwqw92h7ghrjxmsvz2z6l";
    };
    lisp = sbcl;
  };

  cl-ppcre = pkgs.lispPackages_new.build-asdf-system {
    pname = "cl-ppcre";
    version = "2.1.1";
    src = pkgs.fetchzip {
      url = "https://github.com/edicl/cl-ppcre/archive/refs/tags/v2.1.1.tar.gz";
      hash = "sha256-UffzJ2i4wpkShxAJZA8tIILUbBZzbWlseezj2JLImzc=";
    };
    lisp = sbcl;
  };

  clx = pkgs.lispPackages_new.build-asdf-system {
    pname = "clx";
    version = "0.7.5";
    src = pkgs.fetchzip {
      url =
        "https://github.com/sharplispers/clx/archive/refs/tags/0.7.5.tar.gz";
      hash = "sha256-jouNhlB7NkxNi65m+OGBCjBG6+duuco6ybnIC9M/Ju4=";
    };
    lisp = sbcl;
  };

  stumpwm = (pkgs.lispPackages_new.build-asdf-system rec {
    pname = "stumpwm";
    version = "22.11";
    src = pkgs.fetchzip {
      url = "https://github.com/stumpwm/stumpwm/archive/refs/tags/22.11.tar.gz";
      hash = "sha256-zXj17ucgyFhv7P0qEr4cYSVRPGrL1KEIofXWN2trr/M=";
    };
    buildInputs = with pkgs; [ autoconf gnumake ];
    configurePhase = ''
      ./autogen.sh
      export SBCL_PATH="${pkgs.sbcl}/bin/sbcl"
      export SBCL_HOME="${pkgs.sbcl}/lib/sbcl"
      ./configure
    '';
    buildPhase = ''
      export HOME=/tmp/home
      make
    '';
    installPhase = ''
      mkdir -p "$out/bin"
      cp "stumpwm" "$out/bin"
    '';
    lisp = sbcl;
    lispLibs = [ alexandria cl-ppcre clx ];
  });
in {
  options = {
    services.xserver.windowManager.stumpwm-custom.enable =
      lib.mkEnableOption (lib.mdDoc "stumpwm-custom");
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "stumpwm-custom";
      start = ''
        ${stumpwm}/bin/stumpwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ stumpwm ];
  };
}
