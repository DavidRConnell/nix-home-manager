{ config, pkgs, ... }: {

  home.packages = (with pkgs; [ neovim tree exa bat tealdeer difftastic ]);

  programs.zsh = {
    enable = true;
    history.ignoreDups = true;
    history.path = "${config.xdg.dataHome}/zsh/history";
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    oh-my-zsh.enable = false;

    envExtra = ''
      source $ZDOTDIR/realenv.zsh
    '';

    shellAliases = {
      e = "emacsclient -ca ''";
      vi = "nvim";
      stow = "stow --dotfiles";

      gs = "git status";
      gc = "git commit";
      gd = "git diff";
      ga = "git add";

      df = "df -h";
      du = "du -h";
      free = "free -h";

      ls = "exa --group-directories-first";
      l = "exa -la --git --group-directories-first";
      lt = "exa --tree --level=2 --group-directories-first";

      chgrp = "chgrp --preserve-root";
      chown = "chown --preserve-root";
      chmod = "chmod --preserve-root";

      svg = "feh -x --reload 1 --conversion-timeout 1";
      md2pdf =
        "pandoc -V geometry:margin=1in --pdf-engine=xelatex --variable mainfont=Helvetica -t pdf -f gfm -i";
      open = "xdg-open";

      fzf =
        "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
      cat = "bat";

      tmux = "direnv exec / tmux";
    };

    initExtra = ''
      source $ZDOTDIR/realrc.zsh
    '';

    enableAutosuggestions = true;
    enableCompletion = false;
    plugins = with pkgs; [
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
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-autopair";
        file = "autopair.zsh";
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "v1.0";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
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

  programs.git.delta = { enable = true; };
}
