# nix

nix-darwin + home-manager によるマルチプラットフォーム dotfiles 管理。

## 前提

- すべての nix コマンドは `nix/` ディレクトリで実行する
- `flake.nix` は `nix/flake.nix` にある

## 対応ホスト

| ホスト | OS | 管理方式 |
|---|---|---|
| `andouhanshirous-MacBook-Air` | macOS (`aarch64-darwin`) | nix-darwin + home-manager |
| `hosshiiarch` | Arch Linux (`x86_64-linux`) | standalone home-manager |
| `devcontainer-x86_64` | Linux (`x86_64-linux`) | standalone home-manager |
| `devcontainer-aarch64` | Linux (`aarch64-linux`) | standalone home-manager |

## flake outputs

`nix/flake.nix` が公開する主な outputs:

- `darwinConfigurations`
- `homeConfigurations`
- `homeManagerModules.devcontainer`
- `formatter`

`pkgs/overlays` は内部実装であり outputs では公開しない。

## ディレクトリ構成

```text
nix/
├── flake.nix
├── lib/                     # mk-host/mk-home/mk-pkgs と共通定数
├── pkgs/overlays/           # features/* で機能別に分割
├── modules/
│   ├── darwin/              # nix-darwin system modules
│   └── home/                # home-manager modules
├── profiles/
│   ├── base/
│   ├── workstation/
│   └── devcontainer/
└── hosts/
    ├── macbook/
    ├── archlinux/
    └── devcontainer/
```

## 設計ルール

- `modules/` は最小部品、`profiles/` は組み合わせ、`hosts/` は選択のみを担う
- `system` 判定は `lib/mk-pkgs.nix` に集約し、overlay 側に分散させない
- Git identity は `host.identity.git` を単一ソースとして使う
- `_1password` の命名は維持する
- `home.stateVersion` / `system.stateVersion` は `lib/constants.nix` で一元管理する

## ホストごとの profile 構成

- macOS (`hosts/macbook/home.nix`)
  - `profiles/base/home.nix`
  - `profiles/workstation/macos.nix`
  - `hosts/macbook/ssh.nix`
- Arch Linux (`hosts/archlinux/home.nix`)
  - `profiles/base/home.nix`
  - `profiles/workstation/linux.nix`
- devcontainer (`hosts/devcontainer/home.nix`)
  - `profiles/devcontainer/default.nix`
  - `custom.git.name` / `custom.git.email` は `host.identity.git` から注入

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
nix run home-manager -- switch --flake .#hosshii@hosshiiarch
```

### devcontainer

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

## devcontainer profile の扱い

- `profiles/devcontainer/default.nix` は devcontainer 専用 profile
- `git` / `delta` / `git-wt` / `starship` / `zsh` / `claude-code` / `codex` を含む
- `hosts/devcontainer` 経由では `custom.git.name/email` を `host.identity.git` から自動設定する
- 署名を使う場合は `custom.git.signing.enable` と `custom.git.signing.publicKey` を設定する
- `CLAUDE_CONFIG_DIR` / `CODEX_HOME` は XDG (`~/.config/claude-code`, `~/.config/codex`) を使う

## 外部 flake から module として使う

`homeManagerModules.devcontainer` を単体利用する場合は、利用側で `custom.git.name` / `custom.git.email` を設定する。

```nix
{
  inputs.dotfiles.url = "github:Hosshii/dotfiles?dir=nix";

  outputs = { nixpkgs, home-manager, dotfiles, ... }: {
    homeConfigurations."user@host" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        dotfiles.homeManagerModules.devcontainer
        {
          custom.git = {
            name = "Your Name";
            email = "you@example.com";
          };
        }
      ];
    };
  };
}
```

## 新しいモジュールの追加

1. `modules/home/<カテゴリ>/<ツール名>/default.nix` を作成
2. 必要なら `modules/home/<カテゴリ>/default.nix` に追加
3. `profiles/*` へ組み込み
4. `hosts/<ホスト名>/home.nix` で profile を選択

## 新しいホストの追加

1. `hosts/<ホスト名>/host.nix` で metadata（system/hostname/username/homedir/identity）を定義
2. `hosts/<ホスト名>/home.nix` で profile を選択
3. `hosts/<ホスト名>/default.nix` で `lib/mk-host.nix` を使って output を公開
4. `flake.nix` へホストを追加
