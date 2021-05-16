{ pkgs ? import <nixpkgs> { } }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
in emacsWithPackages (epkgs:
(with epkgs.melpaPackages; [
  use-package
  evil
  evil-org
  evil-collection
  evil-goggles
  evil-surround
  evil-nerd-commenter
  py-isort
  magit
  general
  no-littering
  org-roam
  org-roam-bibtex
  org-ref
  org-superstar
  org-cliplink
  visual-fill-column
  elfeed
  elfeed-org
  ebib
  which-key
  rainbow-delimiters
  ranger
  git-gutter
  git-gutter-fringe
  eyebrowse
  ob-async
  ox-clip
  ox-hugo
  ivy-posframe
  ivy-rich
  counsel
  prescient
  company-prescient
  ivy-prescient
  company
  citeproc-org
  ace-window
  projectile
  helpful
  nix-mode
  direnv
  envrc
  nov
  company-shell
  smartparens
  elisp-demos
  format-all
  sly
  geiser
  geiser-guile
  geiser-mit
  amx
  ivy-avy
  sdcv
  wiki-summary
  wordnut
  deft
  emr
  elpy
  pdf-tools
  blacken
  helm-system-packages
  helm-selector
  evil-smartparens
  gcmh
  yasnippet
  hl-todo
  flycheck
  flyspell-correct-ivy
  highlight-indent-guides
  lispy
  lispyville
  highlight-defined
  highlight-function-calls
  elisp-def
  counsel-projectile
  evil-easymotion
  avy
  evil-exchange
  evil-args
  evil-lion
  undo-fu
  undo-fu-session
  link-hint
  dumb-jump
  iedit
]) ++
(with epkgs.elpaPackages; [
  exwm
  modus-themes
]) ++
[ epkgs.orgPackages.org-plus-contrib ])
