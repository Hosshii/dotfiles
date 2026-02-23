# sheldon プラグインの条件付き読み込み (custom option 方式)

## Context

現在 `plugins.toml` は静的ファイルで、starship / zoxide / fzf / direnv のプラグインが常に読み込まれる。各ツールモジュールが自身の sheldon プラグインを custom option 経由で登録し、zsh モジュールが集約・生成する方式に変更する。`custom.git.*` と同じパターン。

## 設計

### option 定義 (`zsh/default.nix`)

```nix
options.custom.sheldon.plugins = lib.mkOption {
  type = lib.types.attrsOf (lib.types.submodule {
    options = {
      text = lib.mkOption {
        type = lib.types.str;
        description = "TOML key-value pairs for this plugin ([plugins.<name>] header is auto-generated)";
      };
      order = lib.mkOption {
        type = lib.types.int;
        default = 500;
        description = "Load order (lower = earlier)";
      };
    };
  });
  default = {};
};
```

### 登録パターン (各ツールモジュール)

```nix
# starship/default.nix
custom.sheldon.plugins.starship = {
  order = 400;
  text = ''inline = "zsh-defer -c 'eval \"$(starship init zsh)\"'"'';
};
```

### TOML 生成 (`zsh/default.nix`)

```nix
let
  cfg = config.custom.sheldon;
  pluginsList = lib.mapAttrsToList (name: p: { inherit name; inherit (p) text order; }) cfg.plugins;
  sortedPlugins = lib.sort (a: b: a.order < b.order) pluginsList;
  pluginToToml = p: ''
[plugins.${p.name}]
${p.text}
'';
  pluginsToml = ''
shell = "zsh"
apply = ["defer"]

[templates]
defer = "{{ hooks?.pre | nl }}{% for file in files %}zsh-defer source \"{{ file }}\"\n{% endfor %}{{ hooks?.post | nl }}"
'' + lib.concatMapStrings pluginToToml sortedPlugins;
in ...
```

### order 値の割り当て

| order | plugin | 定義場所 |
|-------|--------|---------|
| 100 | zsh-defer | zsh/default.nix |
| 200 | zsh-completions | zsh/default.nix |
| 300 | compinit | zsh/default.nix |
| 400 | starship | starship/default.nix |
| 500 | dotfiles-defer | zsh/default.nix |
| 600 | direnv | direnv/default.nix |
| 700 | fzf | fzf/default.nix |
| 800 | zoxide | zoxide/default.nix |
| 900 | zsh-autosuggestions | zsh/default.nix |

## 変更ファイル

### 1. `nix/home/core/zsh/default.nix` — option 定義 + 基本プラグイン登録 + TOML 生成

`custom.git` と同じパターンで `options` / `config` に分離:

```nix
{ pkgs, config, lib, ... }:
let
  cfg = config.custom.sheldon;
  pluginsList = lib.mapAttrsToList (name: p: { inherit name; inherit (p) text order; }) cfg.plugins;
  sortedPlugins = lib.sort (a: b: a.order < b.order) pluginsList;
  pluginToToml = p: ''
[plugins.${p.name}]
${p.text}
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
    default = {};
    description = "Sheldon plugins to include in plugins.toml";
  };

  config = {
    # 基本プラグイン (常に有効)
    custom.sheldon.plugins = {
      zsh-defer = {
        order = 100;
        text = ''
          github = "romkatv/zsh-defer"
          apply = ["source"]'';
      };
      zsh-completions = {
        order = 200;
        text = ''github = "zsh-users/zsh-completions"'';
      };
      compinit = {
        order = 300;
        text = ''inline = "autoload -Uz compinit && zsh-defer compinit"'';
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
      enableZshIntegration = true;
    };

    programs.zsh = {
      # (既存の設定をそのまま維持)
    };
  };
}
```

### 2. `nix/home/core/starship/default.nix` — sheldon プラグイン登録を追加

```nix
{
  programs.starship = {
    enable = true;
    settings = { ... }; # 既存設定はそのまま
  };

  custom.sheldon.plugins.starship = {
    order = 400;
    text = ''inline = "zsh-defer -c 'eval \"$(starship init zsh)\"'"'';
  };
}
```

### 3. `nix/home/core/direnv/default.nix` — sheldon プラグイン登録を追加

```nix
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };

  custom.sheldon.plugins.direnv = {
    order = 600;
    text = ''inline = "zsh-defer -c 'eval \"$(direnv hook zsh)\"'"'';
  };
}
```

### 4. `nix/home/core/fzf/default.nix` — sheldon プラグイン登録を追加

```nix
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    defaultOptions = [ ... ]; # 既存設定はそのまま
  };

  custom.sheldon.plugins.fzf = {
    order = 700;
    text = ''inline = "zsh-defer -c \"source <(fzf --zsh)\""'';
  };
}
```

### 5. `nix/home/core/zoxide/default.nix` — sheldon プラグイン登録を追加

```nix
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };

  custom.sheldon.plugins.zoxide = {
    order = 800;
    text = ''inline = "zsh-defer -c 'eval \"$(zoxide init zsh)\"'"'';
  };
}
```

### 6. `nix/home/core/zsh/plugins.toml` — 削除

`git rm` で削除。内容は Nix による動的生成に移行。

## TOML エスケープ方針

- TOML multiline literal (`'''`) → 単一行 basic string (`"..."`) に統一
- TOML 内の `"` は `\"` でエスケープ (Nix `''` 文字列ではバックスラッシュは特殊文字ではないのでそのまま出力される)
- `$(...)` は Nix で補間されない (`${...}` のみ補間)

## 検証

1. `nix/` ディレクトリで `sudo nix run nix-darwin -- switch --flake .` を実行
2. `~/.config/sheldon/plugins.toml` を確認し、全プラグインが正しい順序で含まれていることを検証
3. 新しいシェルで starship プロンプト・zoxide (`z`)・fzf (`Ctrl+R`)・direnv が正常に動作することを確認
