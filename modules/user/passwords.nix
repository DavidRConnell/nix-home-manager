{ pkgs, ... }: {

  home.packages = [ pkgs.gitAndTools.pass-git-helper ];
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions
      (exts: with exts; [ pass-audit pass-genphrase pass-update ]);
  };
}
