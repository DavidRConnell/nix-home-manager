{ config, pkgs, ... }: {

  home.packages = (with pkgs; [
    tree
    exa
  ]);

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

      svg = "feh -x --reload 1 --conversion-timeout 1";
      md2pdf =
        "pandoc -V geometry:margin=1in --pdf-engine=xelatex --variable mainfont=Helvetica -t pdf -f gfm -i";
      open = "xdg-open";
    };

    initExtra = ''
        source $ZDOTDIR/realrc.zsh
    '';

    enableAutosuggestions = true;
    enableCompletion = true;
    plugins = with pkgs; [
      {
        name = "zsh-vi-mode";
        src = fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "9178e6bea2c8b4f7e998e59ef755820e761610c7";
          sha256 = "0a1rvc03rl66v8rgzvxpq0vw55hxn5b9dkmhdqghvi2f4dvi8fzx";
        };
        file = "zsh-vi-mode.plugin.zsh";
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
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
        file = "autopair.zsh";
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
