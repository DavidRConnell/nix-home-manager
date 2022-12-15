{ config, pkgs, lib, ... }: {
  home.packages = (with pkgs; [ isync mu ]);

  services.mbsync = {
    enable = true;
    verbose = false;
    frequency = "*:0/15";
    # emacs locks mu so mu index will fail.
    postExec =
      "${config.programs.emacs.finalPackage}/bin/emacsclient -e '(mu4e-update-index)'";
  };
}
