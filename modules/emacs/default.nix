{ pkgs, ... }: {

  home.packages = (with pkgs; [
    ccls # For c-mode lsp
    ltex-ls
    nixfmt
    nix-linter
    nodePackages.bash-language-server
    rnix-lsp
    rtags
    shfmt
    sqlite # For org-roam

  ]);

  programs.emacs = {
    enable = true;
    package = import ./packages.nix { inherit pkgs; };
  };

  services.emacs.enable = true;
}
