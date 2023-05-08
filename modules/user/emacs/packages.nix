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
    cython-mode
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
    eyebrowse
    flycheck
    flyspell-correct
    forge
    format-all
    gcmh
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
    marginalia
    markdown-mode
    nix-mode
    no-littering
    nov
    orderless
    pdf-tools
    popper
    prescient
    projectile
    py-isort
    python-pytest
    rainbow-delimiters
    reformatter
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
    citar
    citar-embark
    citar-org-roam
    citeproc
    consult
    consult-flycheck
    corfu
    cypher-mode
    dired-narrow
    # eglot
    embark
    embark-consult
    ement
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
    jinx
    magit
    magit-annex
    ob-async
    org
    org-appear
    org-cliplink
    org-contrib
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
    ox-reveal
    saveplace-pdf-view
    visual-fill-column
    undo-fu
    undo-fu-session
    git-timemachine
    tree-sitter
    (tree-sitter-langs.withPlugins (p:
      tree-sitter-langs.plugins ++ (with p; [
        tree-sitter-bibtex
        tree-sitter-elisp
        tree-sitter-make
        tree-sitter-markdown
        tree-sitter-toml
      ])))
    evil-textobj-tree-sitter
  ]))
