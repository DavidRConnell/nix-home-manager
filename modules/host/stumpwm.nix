{ config, lib, pkgs, ... }:

let
  cfg = config.services.xserver.windowManager.stumpwm-custom;
  stumpwm = (pkgs.sbcl.buildASDFSystem rec {
    pname = "stumpwm";
    version = "23.11";
    src = pkgs.fetchFromGitHub {
      owner = "stumpwm";
      repo = "stumpwm";
      rev = version;
      hash = "sha256-sWCr3wm99Hv4LsZ572921wcUnQV40AmWSUVMWnmfeSo=";
    };
    lispLibs = with pkgs.sbcl.pkgs; [ alexandria cl-ppcre clx slynk ];
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
