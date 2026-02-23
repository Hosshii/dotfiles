# nix

nix-darwin + home-manager によるマルチプラットフォーム dotfiles 管理。

## 対応ホスト

| ホスト | OS | 管理方式 |
|---|---|---|
| `andouhanshirous-MacBook-Air` | macOS (aarch64-darwin) | nix-darwin + home-manager |
| `hosshiiarch` | Arch Linux (x86_64-linux) | standalone home-manager |

## ディレクトリ構成

```
nix/
├── flake.nix                # エントリポイント (outputs 定義)
├── lib/                     # 共通ビルダー / 定数
│   ├── constants.nix        # stateVersion などの共通定数
│   ├── mk-pkgs.nix          # nixpkgs + overlays 組み立て
│   ├── mk-home.nix          # home-manager configuration 生成
│   └── mk-host.nix          # darwin/home host 出力生成
├── pkgs/
│   └── overlays/            # overlay 分類
│       ├── default.nix      # system ごとの overlay 解決
│       ├── common.nix       # 全ホスト共通
│       ├── darwin.nix       # macOS 専用
│       └── linux.nix        # Linux 専用
├── modules/
│   ├── darwin/              # nix-darwin system-level modules
│   │   ├── _1password/
│   │   ├── defaults/
│   │   └── zsh/
│   └── home/                # home-manager modules
│       ├── cli/             # 共通 CLI
│       ├── gui/             # GUI
│       ├── dev/             # 開発向けツール
│       ├── services/        # サービス系クライアント
│       └── security/        # セキュリティ関連 (_1password など)
├── profiles/                # モジュール組み合わせ定義
│   ├── base/
│   │   ├── home.nix
│   │   └── darwin.nix
│   ├── workstation/
│   │   ├── macos.nix
│   │   └── linux.nix
│   └── devcontainer/
│       └── linux.nix
└── hosts/                   # ホスト別設定
    ├── macbook/
    │   ├── host.nix         # ホスト metadata
    │   ├── default.nix      # darwinConfigurations 出力
    │   ├── home.nix         # home profile 選択
    │   └── ssh.nix          # arch への SSH 接続設定
    └── archlinux/
        ├── host.nix         # ホスト metadata
        ├── default.nix      # homeConfigurations 出力
        └── home.nix         # home profile 選択
```

## 設計方針

- **`modules/`** は再利用可能な最小部品。ツール単位で独立させる
- **`profiles/`** は modules の組み合わせ。`base` + `workstation/*` で構成する
- **`hosts/`** は metadata と profile 選択のみを担い、モジュール詳細は持たない
- **`pkgs/overlays/`** は `common` / `darwin` / `linux` で分類する
- `ghq` は `modules/home/cli/git` モジュールの `custom.git.ghq.enable` で管理する
- `_1password` の命名は維持する（ディレクトリ名・オプション名とも変更しない）

### stateVersion の運用

- `home.stateVersion` は `lib/constants.nix` の `homeStateVersion` で管理する
- `system.stateVersion` は `lib/constants.nix` の `darwinStateVersion` で管理する

### ホスト別モジュール選択

| Profile / Module | macOS | Arch Linux |
|---|---|---|
| `profiles/base/home` | o | o |
| `profiles/workstation/macos` | o | |
| `profiles/workstation/linux` | | o |
| `modules/home/gui` (full) | o | |
| `modules/home/gui/alacritty` + `fonts` | | o |
| `modules/home/dev` (full) | o | |
| `modules/home/dev/binutils` `cmake` `pstree` `time` | | o |
| `modules/home/services` | o | |
| `modules/home/security/_1password` | o | |
| `hosts/macbook/ssh.nix` | o | |

## 使い方

### macOS

```bash
# ビルド
sudo nix run nix-darwin -- build --flake .

# 適用
sudo nix run nix-darwin -- switch --flake .
```

### Arch Linux

```bash
# 適用
nix run home-manager -- switch --flake .#hosshii@hosshiiarch
```

### フォーマット

```bash
nix fmt
```

### devcontainer profile

- `profiles/devcontainer/linux.nix` は devcontainer 向けの専用 profile
- 既存の `profiles/workstation/*` や `hosts/*` には自動適用しない

### 外部 flake から参照

```nix
{
  inputs.dotfiles.url = "github:Hosshii/dotfiles?dir=nix";

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }: {
    homeConfigurations."user@host" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        dotfiles.homeManagerModules.devcontainer
      ];
    };
  };
}
```

## 新しいモジュールの追加方法

1. `modules/home/<カテゴリ>/<ツール名>/default.nix` を作成する
2. 必要ならカテゴリ集約 `modules/home/<カテゴリ>/default.nix` に追加する
3. 適用先 profile (`profiles/base|workstation`) に module を追加する
4. ホスト単位の採用は `hosts/<host>/home.nix` の profile 選択で行う

## 新しいホストの追加方法

1. `hosts/<ホスト名>/host.nix` を作成し metadata（system/hostname/username/homedir）を定義する
2. `hosts/<ホスト名>/home.nix` で home profile を選択する
3. `hosts/<ホスト名>/default.nix` で `lib/mk-host.nix` を使って output と darwin profile を公開する
4. `flake.nix` にホストを追加する
