{ pkgs, ... }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in emacsWithPackages (epkgs:
  (with epkgs.melpaPackages; [
    ace-window
    bats-mode
    cython-mode
    deft
    direnv
    dumb-jump
    ebib
    elfeed
    elfeed-org
    elisp-def
    elisp-demos
    ess
    flyspell-correct
    forge
    format-all
    gcmh
    general
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
    magit-todos
    markdown-mode
    nix-mode
    no-littering
    package-lint
    python-pytest
    rainbow-delimiters
    reformatter
    smartparens
    transient
    which-key
    wiki-summary
    wordnut
    yasnippet
    yasnippet-capf
    yatemplate
  ]) ++ (with epkgs.elpaPackages; [
    aggressive-indent
    cape
    consult
    corfu
    jinx
    marginalia
    orderless
    popper
    vertico
    vundo
  ]) ++ (with epkgs; [
    avy
    citar
    citar-embark
    citar-org-roam
    citeproc
    corfu-prescient
    cypher-mode
    diff-hl
    dired-narrow
    # edit-indirect
    embark
    embark-consult
    engrave-faces
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
    evil-textobj-tree-sitter
    flymake-proselint
    git-timemachine
    gptel
    matlab-mode
    mermaid-mode
    nov
    ob-mermaid
    org
    org-appear
    org-cliplink
    org-contrib
    org-pomodoro
    org-roam
    org-roam-bibtex
    org-superstar
    ox-pandoc
    # poly-markdown
    prescient
    projectile
    scad-mode
    sdcv
    undo-fu-session
    vertico-prescient
    visual-fill-column
    wgrep

    treesit-grammars.with-all-grammars
  ]))
