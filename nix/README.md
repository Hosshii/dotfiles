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
├── flake.nix              # エントリポイント (ホスト定義 + outputs)
├── darwin/                # macOS system-level 設定
│   ├── default.nix        # nix-darwin メイン (nixpkgs, stateVersion 等)
│   ├── _1password/        # 1Password (システムレベル)
│   └── zsh/               # zsh (ログインシェル設定)
├── home/                  # home-manager モジュールライブラリ
│   ├── core/              # CLI ツール (全ホスト共通)
│   │   ├── default.nix    # 集約モジュール (全 core を import)
│   │   ├── bat/           # bat
│   │   ├── direnv/        # direnv
│   │   ├── dust/          # dust
│   │   ├── eza/           # eza
│   │   ├── fd/            # fd
│   │   ├── fzf/           # fzf
│   │   ├── ghq/           # ghq
│   │   ├── git/           # git
│   │   ├── htop/          # htop
│   │   ├── jq/            # jq
│   │   ├── onefetch/      # onefetch
│   │   ├── ripgrep/       # ripgrep
│   │   ├── sccache/       # sccache
│   │   ├── ssh/           # SSH (共通設定のみ)
│   │   ├── starship/      # starship
│   │   ├── tmux/          # tmux
│   │   ├── tokei/         # tokei
│   │   ├── tree/          # tree
│   │   ├── vim/           # vim
│   │   ├── wget/          # wget
│   │   ├── zoxide/        # zoxide
│   │   └── zsh/           # zsh
│   ├── gui/               # GUI アプリ
│   │   ├── default.nix    # 集約モジュール
│   │   ├── alacritty/     # Alacritty
│   │   ├── fonts/         # フォント
│   │   ├── hammerspoon/   # Hammerspoon
│   │   ├── raycast/       # Raycast
│   │   ├── discord/       # Discord (未使用)
│   │   ├── firefox/       # Firefox (未使用)
│   │   ├── google-chrome/ # Google Chrome (未使用)
│   │   └── vscode/        # VS Code (未使用)
│   ├── opt/               # オプションツール
│   │   ├── default.nix    # 集約モジュール
│   │   ├── binutils/      # binutils
│   │   ├── cmake/         # cmake
│   │   ├── pstree/        # pstree
│   │   ├── terminal-notifier/ # terminal-notifier (macOS のみ)
│   │   └── time/          # GNU time
│   └── _1password/        # 1Password モジュール (home-manager レベル)
└── hosts/                 # ホスト別設定
    ├── macbook/
    │   ├── default.nix    # ホスト変数定義 + nix-darwin 設定
    │   ├── home.nix       # macOS の home-manager 設定
    │   └── ssh.nix        # arch への SSH 接続設定
    └── archlinux/
        ├── default.nix    # ホスト変数定義 + home-manager 設定
        └── home.nix       # Arch Linux の home-manager 設定
```

## 設計方針

- **`home/`** はモジュールライブラリ。個々のツール設定を独立したモジュールとして定義
- **`home/core/`** は全ホスト共通の CLI ツール群。集約 `default.nix` で一括 import 可能
- **`hosts/`** はホストごとにどのモジュールを import するか制御する
- **`darwin/`** は macOS のシステムレベル設定 (nix-darwin)。home-manager とは別レイヤー

### ホスト別モジュール選択

| モジュール | macOS | Arch Linux |
|---|---|---|
| `home/core` (全て) | o | o |
| `home/gui/alacritty` | o | o |
| `home/gui/fonts` | o | o |
| `home/gui/hammerspoon` | o | |
| `home/gui/raycast` | o | |
| `home/opt` (全て) | o | |
| `home/opt` (terminal-notifier 以外) | | o |
| `home/_1password` | o | |
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

## 新しいモジュールの追加方法

1. `home/<カテゴリ>/<ツール名>/default.nix` にモジュールを作成
2. 全ホストで使う場合は集約 `default.nix` (`home/core/default.nix` 等) に追加
3. 特定ホストのみの場合は `hosts/<ホスト名>/home.nix` の imports に直接追加

## 新しいホストの追加方法

1. `hosts/<ホスト名>/default.nix` を作成し、ホスト変数（ユーザー名、ホームディレクトリ等）を定義
2. `hosts/<ホスト名>/home.nix` を作成し、必要なモジュールを import
3. `flake.nix` にホストの configuration を追加
