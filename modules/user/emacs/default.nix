{ pkgs, ... }: {

  home.packages = (with pkgs; [
    nixfmt
    nil
    pkgconf
    statix
    nixpkgs-hammering
    readability-cli
    emacs-lsp-booster
    proselint
    (python3.withPackages (p: [ p.python-lsp-server ]))
    matlab-language-server
    dockfmt
    bash-language-server
    shellcheck
    shfmt
    html-tidy
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
