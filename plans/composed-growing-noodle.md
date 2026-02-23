# git モジュールに git-wt / ghq / delta オプションを追加

## Context

現在 `git-wt` は Nix モジュール化されておらず、`common_config` に `[wt]` セクションが常に含まれている。`ghq` は `nix/home/core/ghq/` に独立モジュールとして存在し全ホストにインストールされている。`delta` は git モジュール内で常に有効化されている。

これらをgitモジュールのオプションとして統合し、ホストごとに有効/無効を制御できるようにする。

## 変更対象ファイル

| ファイル | 操作 |
|---|---|
| `nix/home/core/git/default.nix` | 編集: wt/ghq/delta オプション追加・条件分岐 |
| `nix/home/core/git/common_config` | 編集: `[ghq]` と `[wt]` セクションを削除 |
| `nix/home/core/git/wt_config` | 新規作成: `[wt]` セクションを格納 |
| `nix/home/core/git/ghq_config` | 新規作成: `[ghq]` セクションを格納 |
| `nix/home/core/ghq/default.nix` | 削除 |
| `nix/home/core/default.nix` | 編集: ghq の import を削除 |
| `nix/hosts/macbook/home.nix` | 編集: オプション有効化 |
| `nix/hosts/archlinux/home.nix` | 編集: オプション有効化 |

## 実装手順

### 1. `nix/home/core/git/default.nix` にオプション追加

`options.custom.git` に以下を追加:

```nix
wt = {
  enable = lib.mkEnableOption "git-wt (worktree helper)";
};
ghq = {
  enable = lib.mkEnableOption "ghq (repository manager)";
};
delta = {
  enable = lib.mkEnableOption "delta (git pager)";
};
```

関数引数に `pkgs` を追加する。

```nix
{ config, lib, pkgs, ... }:
```

`config` を `lib.mkMerge` で構成:

```nix
config = lib.mkMerge [
  {
    # 既存のgit設定（常に有効）
    programs.git = {
      enable = true;
      includes = [{ path = ./common_config; }];
      settings.user = { name = cfg.name; email = cfg.email; };
      ignores = [ ... ];
    };
  }
  (lib.mkIf cfg.delta.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "side-by-side line-numbers decorations";
        whitespace-error-style = "22 reverse";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
    };
  })
  (lib.mkIf cfg.wt.enable {
    home.packages = [ pkgs.git-wt ];
    programs.git.includes = [{ path = ./wt_config; }];
  })
  (lib.mkIf cfg.ghq.enable {
    home.packages = [ pkgs.ghq ];
    programs.git.includes = [{ path = ./ghq_config; }];
  })
];
```

### 2. `common_config` から `[ghq]` と `[wt]` セクションを削除

`[ghq]` セクション（13-14行目）と `[wt]` セクション（36-40行目）を削除する。

### 3. `nix/home/core/git/wt_config` を新規作成

```ini
[wt]
	basedir = ".wt"
	copyignored = true
	nocopy = target/
	nocopy = node_modules/
```

`nocopy` が複数キーのため、Nix attrset では表現できない。git includes ファイルとして管理する。

### 4. `nix/home/core/git/ghq_config` を新規作成

```ini
[ghq]
	root = ~/Workspace
```

### 5. `nix/home/core/ghq/default.nix` を削除

独立モジュールは不要になる。

### 6. `nix/home/core/default.nix` から ghq import を削除

`./ghq/default.nix` の行を削除する。

### 7. ホスト設定でオプションを有効化

両ホストの `home.nix` の `custom.git` に以下を追加:

```nix
custom.git = {
  name = "Hosshii";
  email = "...";
  ghq.enable = true;
  wt.enable = true;
  delta.enable = true;
};
```

## 検証

1. `nix/` ディレクトリで `nix fmt` を実行してフォーマット確認
2. macOS: `sudo nix run nix-darwin -- switch --flake .` でビルド・適用確認
3. 適用後に `git config --get ghq.root` と `git config --get wt.basedir` で設定反映を確認
4. `which git-wt` と `which ghq` と `which delta` でパッケージインストールを確認
