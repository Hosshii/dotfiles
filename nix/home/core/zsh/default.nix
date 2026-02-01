{ pkgs
, config
, lib
, ...
}:
{
  xdg = {
    enable = true;
    configFile = {
      "sheldon/plugins.toml".source = pkgs.replaceVars ./plugins.toml {
        configHome = config.xdg.configHome;
      };

      # dotfiles-defer で読み込む設定ファイル
      "zsh/sheldon-config".source = ./config;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false; # sheldon で管理するため無効化
    dotDir = "${config.xdg.configHome}/zsh";

    # emacs keybind
    defaultKeymap = "emacs";

    history = {
      size = 1000000;
      save = 1000000;
      extended = true;
      ignoreDups = true;
      share = true;
      expireDuplicatesFirst = true;
    };

    initContent = ''
      # コマンドミス修正
      setopt correct

      # 単語の入力途中でもTab補完を有効化
      setopt complete_in_word

      # コマンド実行後すぐに履歴に追加
      setopt inc_append_history

      # 補完時にヒストリを自動的に展開
      setopt hist_expand

      # Execute code that does not affect the current session in the background.
      {
        # Compile the completion dump to increase startup speed.
        zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"
        if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
          zcompile "$zcompdump"
        fi
      } &!
    '';

    sessionVariables = {
      # XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      # XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      # XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
      # XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };

  programs.sheldon = {
    enable = true;
    enableZshIntegration = true; # eval "$(sheldon source)" を自動追加
  };
}
