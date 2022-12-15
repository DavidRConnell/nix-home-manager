{ pkgs, ... }: {

  home.packages = (with pkgs; [
    ccls # For c-mode lsp
    delta # For magit-delta
    ltex-ls
    nixfmt
    nix-linter
    rnix-lsp

    nodePackages.bash-language-server
    shfmt
    rtags
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
