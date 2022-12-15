{ pkgs, ... }:

let
  myEmacs = pkgs.emacsUnstable;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in emacsWithPackages (epkgs:
  (with epkgs.melpaPackages; [
    ace-window
    avy
    bats-mode
    blacken
    cape
    ccls
    citar
    citar-embark
    citeproc
    consult
    consult-flycheck
    cython-mode
    deft
    direnv
    dumb-jump
    ebib
    eglot
    elfeed
    elfeed-org
    elisp-def
    elisp-demos
    elpher
    elpy
    embark
    embark-consult
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
    flyspell-correct
    forge
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
    magit-annex
    magit-delta
    marginalia
    markdown-mode
    nix-mode
    no-littering
    nov
    ob-async
    orderless
    org-appear
    org-cliplink
    orgit
    orgit-forge
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
    python-pytest
    rainbow-delimiters
    sly
    smartparens
    transient
    use-package
    vlf
    which-key
    wiki-summary
    wordnut
    yasnippet
    yatemplate
  ]) ++ (with epkgs.elpaPackages; [ modus-themes vertico vundo ])

  ++ (with epkgs; [
    org-contrib
    corfu
    cypher-mode
    ement
    # visual-fill-column
    # undo-fu
    # undo-fu-session
    # git-timemachine
    tree-sitter
    (tree-sitter-langs.withPlugins (p:
      tree-sitter-langs.plugins ++ (with p; [
        tree-sitter-bibtex
        tree-sitter-elisp
        tree-sitter-make
        tree-sitter-markdown
        tree-sitter-r
        tree-sitter-toml
        tree-sitter-yaml
      ])))
    evil-textobj-tree-sitter
  ]))
