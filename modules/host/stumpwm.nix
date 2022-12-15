{ config, lib, pkgs, ... }:

with lib;

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
    version = "20220808-git";
    src = pkgs.fetchFromGitHub {
      owner = "sharplispers";
      repo = "clx";
      rev = "master";
      hash = "sha256-Dgo/oOa3xP3HnXWlwgUBfhYR8HRFrg1ud1iqb2JETG4=";
    };
    lisp = sbcl;
  };

  # clx-truetype = pkgs.lispPackages_new.build-asdf-system {
  #   pname = "clx-truetype";
  #   version = "20160701-git";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "l04m33";
  #     repo = "clx-truetype";
  #     rev = "master";
  #     hash = "sha256-Z8giQ6rW8E/DoNY4RTz5C8cVLc+6T7iMdW1KJtL1MB0=";
  #   };
  #   lisp = sbcl;
  #   lispLibs = [ clx ];
  # };

  # slynk = pkgs.lispPackages_new.build-asdf-system {
  #   pname = "slynk";
  #   version = "20221108-git";
  #   src = pkgs.fetchurl {
  #     url = "https://github.com/joaotavora/sly/tree/master/slynk";
  #     hash = "sha256-UxlXtMXhi4WTc0/xvKnTkB7sbsuezN2Zq7ZEhGjDf3w=";
  #   };
  #   lisp = sbcl;
  # };

  stumpwm = pkgs.lispPackages_new.build-asdf-system {
    pname = "stumpwm";
    version = "22.11";
    src = pkgs.fetchzip {
      url = "https://github.com/stumpwm/stumpwm/archive/refs/tags/22.11.tar.gz";
      hash = "sha256-zXj17ucgyFhv7P0qEr4cYSVRPGrL1KEIofXWN2trr/M=";
    };

    lisp = sbcl;
    lispLibs = [
      alexandria
      cl-ppcre
      clx
      # clx-truetype
      #slynk
    ];
  };

  # stumpwm = pkgs.stdenvNoCC.mkDerivation rec {
  #   pname = "stumpwm";
  #   version = "22.11";

  #   description = "A tiling, keyboard driven window manager";

  #   buildInputs = with pkgs; [ sbcl gnumake bash autoconf texinfo ];
  #   propagatedBuildInputs = with pkgs.lispPackages; [
  #     alexandria
  #     cl-ppcre
  #     clx
  #     clx-truetype
  #     slynk
  #   ];

  #   src = pkgs.fetchurl {
  #     url =
  #       "https://github.com/stumpwm/${pname}/archive/refs/tags/${version}.tar.gz";
  #     sha256 = "09phbrgcaq3k7dyvs79dcm6gi0zs7h8899ykm0cl598v5hxhz51n";
  #   };

  #   configurePhase = ''
  #     runHook preConfigure

  #     export SBCL_HOME=${sbcl}/bin
  #     ./autogen.sh
  #     ./configure

  #     runHook postConfigure
  #   '';

  #   buildPhase = ''
  #     make
  #   '';

  #   installPhase = ''
  #     mkdir "$out"/bin
  #     cp stumpwm "$out"/bin
  #   '';
  # };

in {
  options = {
    services.xserver.windowManager.stumpwm-custom.enable =
      mkEnableOption (lib.mdDoc "stumpwm-custom");
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "stumpwm";
      start = ''
        ${stumpwm}/bin/stumpwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ stumpwm ];
  };
}
