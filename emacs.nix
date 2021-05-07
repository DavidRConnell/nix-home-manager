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
  org-ref
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
  prescient
  ivy-posframe
  ivy-rich
  counsel
  ivy-prescient
  company
  company-prescient
  citeproc-org
  ace-window
  projectile
  helpful
  nix-mode
  direnv
  smartparens
  elisp-demos
  format-all
  sly
  helm-system-packages
  helm-selector
  evil-smartparens
  gcmh
  yasnippet
  hl-todo
  flycheck
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
  link-hint
  dumb-jump
  iedit
]) ++
(with epkgs.elpaPackages; [
  modus-themes
]) ++
[ epkgs.orgPackages.org-plus-contrib ])
