{ pkgs
, config
, lib
, ...
}:
let
  cfg = config.custom.sheldon;
  pluginsList = lib.mapAttrsToList (name: p: { inherit name; inherit (p) text order; }) cfg.plugins;
  sortedPlugins = lib.sort (a: b: a.order < b.order) pluginsList;
  pluginToToml = p: ''

    [plugins.${p.name}]
    ${lib.removePrefix "\n" p.text}
  '';
  pluginsToml = ''
    shell = "zsh"
    apply = ["defer"]

    [templates]
    defer = "{{ hooks?.pre | nl }}{% for file in files %}zsh-defer source \"{{ file }}\"\n{% endfor %}{{ hooks?.post | nl }}"
  '' + lib.concatMapStrings pluginToToml sortedPlugins;
in
{
  options.custom.sheldon.plugins = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        text = lib.mkOption {
          type = lib.types.str;
          description = "TOML key-value pairs for this plugin";
        };
        order = lib.mkOption {
          type = lib.types.int;
          default = 500;
          description = "Load order (lower = earlier)";
        };
      };
    });
    default = { };
    description = "Sheldon plugins to include in plugins.toml";
  };

  config = {
    custom.sheldon.plugins = {
      zsh-defer = {
        order = 100;
        text = ''
          github = "romkatv/zsh-defer"
          apply = ["source"]'';
      };
      # fpath 追加、compinit 前に必要
      zsh-completions = {
        order = 200;
        text = ''github = "zsh-users/zsh-completions"'';
      };
      compinit = {
        order = 300;
        text = "inline = '''
autoload -Uz compinit && zsh-defer compinit
'''";
      };
      dotfiles-defer = {
        order = 500;
        text = ''
          local = "${config.xdg.configHome}/zsh/sheldon-config"
          use = ["*.zsh"]'';
      };
      zsh-autosuggestions = {
        order = 900;
        text = ''github = "zsh-users/zsh-autosuggestions"'';
      };
    };

    xdg = {
      enable = true;
      configFile = {
        "sheldon/plugins.toml".text = pluginsToml;
        "zsh/sheldon-config".source = ./config;
      };
    };

    programs.sheldon = {
      enable = true;
      enableZshIntegration = true; # eval "$(sheldon source)" を自動追加
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
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      };
    };
  };
}
