{ pkgs, ... }: {

  home.packages = (with pkgs; [
    ccls # For c-mode lsp
    ltex-ls
    nixfmt
    nil
    nix-linter
    enchant
    pkgconf
    statix
    nixpkgs-hammering
    rnix-lsp

    (python3.withPackages (p: [ p.python-lsp-server ]))
    nodePackages.bash-language-server
    shfmt
    sqlite # For org-roam
    jdt-language-server

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
