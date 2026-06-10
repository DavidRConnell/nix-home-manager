{ pkgs, ... }: {

  home.packages = [ pkgs.pass-git-helper pkgs.zbar ];
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions
      (exts: with exts; [ pass-audit pass-genphrase pass-update pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store"; };
  };
}
