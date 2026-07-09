{ config, pkgs, ... }: {

  home.packages = (
    with pkgs;
    [
      neovim
      tree
      eza
      bat
      tealdeer
      difftastic
    ]
  );

  programs.zsh = {
    enable = true;
    history.ignoreDups = true;
    history.path = "${config.xdg.dataHome}/zsh/history";
    dotDir = "${config.xdg.configHome}/zsh";
    defaultKeymap = "viins";
    oh-my-zsh.enable = false;

    envExtra = ''
      source $ZDOTDIR/realenv.zsh
    '';

    shellAliases = {
      e = "emacsclient -ca ''";
      vi = "nvim";
      stow = "stow --dotfiles";
      feh = "feh -Tdefault";

      gs = "git status";
      gc = "git commit";
      gd = "git diff";
      ga = "git add";

      df = "df -h";
      du = "du -h";
      free = "free -h";

      ls = "eza --group-directories-first";
      l = "eza -la --git --group-directories-first";
      lt = "eza --tree --level=2 --group-directories-first";

      chgrp = "chgrp --preserve-root";
      chown = "chown --preserve-root";
      chmod = "chmod --preserve-root";

      svg = "feh -x --reload 1 --conversion-timeout 1";
      md2pdf = "pandoc -V geometry:margin=1in --pdf-engine=xelatex --variable mainfont=Helvetica -t pdf -f gfm -i";
      open = "xdg-open";

      fzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
      cat = "bat";

      tmux = "direnv exec / tmux";
    };

    initContent = ''
      source $ZDOTDIR/realrc.zsh
    '';

    autosuggestion.enable = true;
    enableCompletion = false;
    plugins = [
      {
        name = "zsh-vi-mode";
        file = "zsh-vi-mode.plugin.zsh";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "zsh-fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
      }
      {
        name = "zsh-autopair";
        file = "autopair.zsh";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
      }
      {
        name = "zsh-system-clipboard";
        file = "zsh-system-clipboard.plugin.zsh";
        src = "${pkgs.zsh-clipboard}/share/zsh/zsh-clipboard";
      }
    ];
  };

  programs.htop = {
    enable = true;
    settings.tree_view = true;
  };

  programs.pazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
