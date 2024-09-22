{ pkgs, ... }: {

  home.packages = (with pkgs; [
    ccls # For c-mode lsp
    nixfmt-classic
    nil
    pkgconf
    statix
    nixpkgs-hammering
    readability-cli
    emacs-lsp-booster
    proselint
    (python3.withPackages (p: [ p.python-lsp-server ]))
    nodePackages.bash-language-server
    shellcheck
    shfmt
    prettierd
    yaml-language-server
    cmake-language-server
    cmake-format
    sqlite # For org-roam

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeTypes = [ "x-scheme-handler/org-protocol" ];
    })
  ]);

  programs.emacs = {
    enable = true;
    package = import ./packages.nix { inherit pkgs; };
  };

  services.emacs.enable = true;
}
