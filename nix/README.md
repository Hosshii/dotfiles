# nix

nix-darwin + home-manager によるマルチプラットフォーム dotfiles 管理。

## 対応ホスト

| ホスト | OS | 管理方式 |
|---|---|---|
| `andouhanshirous-MacBook-Air` | macOS (aarch64-darwin) | nix-darwin + home-manager |
| `hosshiiarch` | Arch Linux (x86_64-linux) | standalone home-manager |
| `devcontainer-x86_64` | Linux (x86_64-linux) | standalone home-manager |
| `devcontainer-aarch64` | Linux (aarch64-linux) | standalone home-manager |

## ディレクトリ構成

```
nix/
├── flake.nix                # エントリポイント (outputs 定義)
├── lib/                     # 共通ビルダー / 定数
│   ├── constants.nix        # stateVersion などの共通定数
│   ├── identities.nix       # name/email など個人 identity 定義
│   ├── mk-pkgs.nix          # nixpkgs + overlays 組み立て
│   ├── mk-home.nix          # home-manager configuration 生成
│   └── mk-host.nix          # darwin/home host 出力生成
├── pkgs/
│   └── overlays/            # overlay 定義
│       ├── default.nix      # overlay セット集約（system 判定なし）
│       └── features/        # 機能別 overlay
│           ├── ai.nix
│           ├── base.nix
│           └── brew.nix
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
│       └── default.nix
└── hosts/                   # ホスト別設定
    ├── macbook/
    │   ├── host.nix         # ホスト metadata
    │   ├── default.nix      # darwinConfigurations 出力
    │   ├── home.nix         # home profile 選択
    │   └── ssh.nix          # arch への SSH 接続設定
    ├── archlinux/
    │   ├── host.nix         # ホスト metadata
    │   ├── default.nix      # homeConfigurations 出力
    │   └── home.nix         # home profile 選択
    └── devcontainer/
        ├── host-x86_64.nix  # x86_64-linux metadata
        ├── host-aarch64.nix # aarch64-linux metadata
        ├── default.nix      # homeConfigurations 出力
        └── home.nix         # devcontainer profile 選択
```

## 設計方針

- **`modules/`** は再利用可能な最小部品。ツール単位で独立させる
- **`profiles/`** は modules の組み合わせ。`base` + `workstation/*` で構成する
- **`hosts/`** は metadata と profile 選択のみを担い、モジュール詳細は持たない
- **`pkgs/overlays/`** は `features/*` で機能別に分割し、`system` 判定は `lib/mk-pkgs.nix` に集約する
- Git identity（`name` / `email`）は `host.identity.git` を単一ソースとして管理する
- `ghq` は `modules/home/cli/git` モジュールの `custom.git.ghq.enable` で管理する
- Git 署名（SSH）は `custom.git.signing` で管理する
- `modules/home/security/_1password` は 1Password の CLI/GUI と SSH agent 連携のみを担う
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

### devcontainer (Linux)

```bash
# x86_64-linux
nix run home-manager -- switch --flake .#vscode@devcontainer-x86_64

# aarch64-linux
nix run home-manager -- switch --flake .#vscode@devcontainer-aarch64
```

### フォーマット

```bash
nix fmt
```

### devcontainer profile

- `profiles/devcontainer/default.nix` は devcontainer 向けの専用 profile
- `git` / `delta` / `git-wt` / `starship` / `zsh` / `claude-code` / `codex` を含む
- 既存の `profiles/workstation/*` や `hosts/*` には自動適用しない
- この repo では `hosts/devcontainer` に `x86_64-linux` / `aarch64-linux` host を用意している
- `hosts/devcontainer` 経由で使う場合、`custom.git.name` / `custom.git.email` は `host.identity.git` から自動設定される
- 外部 flake から module 単体で使う場合は、利用側で `custom.git.name` / `custom.git.email` を設定する
- 署名を有効化する場合は `custom.git.signing.enable = true` と `custom.git.signing.publicKey` を設定する
- `rust` / `node` / `protoc` / `mise` の toolchain は profile ではなく `devShell` 管理を推奨
- `CLAUDE_CONFIG_DIR` / `CODEX_HOME` は XDG (`~/.config/claude-code`, `~/.config/codex`) を使用する

### 外部 flake から参照

```nix
{
  inputs.dotfiles.url = "github:Hosshii/dotfiles?dir=nix";

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }:
    let
      system = "x86_64-linux";
    in
  {
    homeConfigurations."user@host" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        dotfiles.homeManagerModules.devcontainer
        {
          custom.git = {
            name = "Your Name";
            email = "you@example.com";
            signing = {
              enable = true;
              publicKey = "ssh-ed25519 AAAAC3Nza... your-key";
            };
          };
        }
      ];
    };
  };
}
```

- `overlays` は内部実装として扱い、`outputs` では公開しない
- 署名を使う場合、コンテナ内で `SSH_AUTH_SOCK` が有効であること（agent forwarding / socket mount）が前提

## 新しいモジュールの追加方法

1. `modules/home/<カテゴリ>/<ツール名>/default.nix` を作成する
2. 必要ならカテゴリ集約 `modules/home/<カテゴリ>/default.nix` に追加する
3. 適用先 profile (`profiles/base|workstation`) に module を追加する
4. ホスト単位の採用は `hosts/<host>/home.nix` の profile 選択で行う

## 新しいホストの追加方法

1. `hosts/<ホスト名>/host.nix` を作成し metadata（system/hostname/username/homedir/identity）を定義する
2. `hosts/<ホスト名>/home.nix` で home profile を選択する
3. `hosts/<ホスト名>/default.nix` で `lib/mk-host.nix` を使って output と darwin profile を公開する
4. `flake.nix` にホストを追加する
