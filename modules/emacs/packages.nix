{ pkgs ? import <nixpkgs> { } }:

let
  myEmacs = pkgs.emacsNativeComp;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in emacsWithPackages (epkgs:
  (with epkgs.melpaPackages; [
    ace-window
    avy
    bats-mode
    blacken
    ccls
    citeproc
    deft
    direnv
    dumb-jump
    ebib
    elfeed
    elfeed-org
    elisp-def
    elisp-demos
    elpher
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
    gnuplot-mode
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
    org-appear
    org-cliplink
    org-ref
    org-roam
    org-roam-bibtex
    org-roam-ui
    org-superstar
    ox-clip
    ox-hugo
    ox-pandoc
    pdf-tools
    popper
    prescient
    projectile
    py-isort
    rainbow-delimiters
    ranger
    rtags
    # sdcv
    sentence-navigation
    sly
    smartparens
    transient
    transient-posframe
    tree-sitter
    tree-sitter-langs
    undo-fu
    undo-fu-session
    use-package
    visual-fill-column
    vlf
    which-key
    wiki-summary
    wordnut
    yasnippet
    yatemplate

    # Completion
    consult
    consult-flycheck
    citar
    embark
    embark-consult
    flyspell-correct
    marginalia
    orderless

    eglot
  ]) ++ (with epkgs.elpaPackages; [ modus-themes vertico ])
  ++ [ epkgs.org-contrib ])
