{ pkgs ? import <nixpkgs> { } }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
in emacsWithPackages (epkgs:
  (with epkgs.melpaPackages; [
    ace-window
    avy
    blacken
    ccls
    citeproc-org
    deft
    direnv
    dumb-jump
    ebib
    elfeed
    elfeed-org
    elisp-def
    elisp-demos
    elpy
    emr
    ess
    ess-R-data-view
    evil
    evil-args
    evil-collection
    evil-easymotion
    evil-exchange
    evil-goggles
    evil-lion
    evil-nerd-commenter
    evil-org
    evil-smartparens
    evil-surround
    eyebrowse
    flycheck
    format-all
    gcmh
    geiser
    geiser-guile
    geiser-mit
    general
    git-gutter
    git-gutter-fringe
    helpful
    highlight-defined
    highlight-function-calls
    highlight-indent-guides
    hl-todo
    iedit
    link-hint
    lispy
    lispyville
    magit
    markdown-mode
    nix-mode
    no-littering
    nov
    ob-async
    org-cliplink
    org-ref
    org-roam
    org-roam-bibtex
    org-superstar
    ox-clip
    ox-hugo
    pdf-tools
    prescient
    projectile
    py-isort
    rainbow-delimiters
    ranger
    sdcv
    sly
    smartparens
    undo-fu
    undo-fu-session
    use-package
    visual-fill-column
    which-key
    wiki-summary
    wordnut
    yasnippet

    # Completion
    bibtex-actions
    consult
    consult-flycheck
    flyspell-correct
    embark
    embark-consult
    marginalia
    orderless

    # LSP
    lsp-mode

  ]) ++ (with epkgs.elpaPackages; [ modus-themes vertico ])
  ++ [ epkgs.orgPackages.org-plus-contrib ])
