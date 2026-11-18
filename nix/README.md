# nix

nix-darwin + home-manager によるマルチプラットフォーム dotfiles 管理。

## 前提

- `--flake .#...` を使うコマンドは `nix/` ディレクトリで実行する
- `--flake "github:..."` を使うコマンドは任意ディレクトリで実行できる
- `flake.nix` は `nix/flake.nix` にある

## 対応ホスト

| ホスト | OS | 管理方式 |
|---|---|---|
| `Hoshiros-MacBook-Air` | macOS (`aarch64-darwin`) | nix-darwin + home-manager |
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

### GitHub リポジトリを直接参照して適用

```bash
# macOS
sudo nix run --refresh nix-darwin#darwin-rebuild -- switch --flake "github:Hosshii/dotfiles?dir=nix#Hoshiros-MacBook-Air"

# Arch Linux
nix run --refresh home-manager#home-manager -- switch --flake "github:Hosshii/dotfiles?dir=nix#hosshii@hosshiiarch"

# devcontainer x86_64-linux
nix run --refresh home-manager#home-manager -- switch --flake "github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-x86_64"

# devcontainer aarch64-linux
nix run --refresh home-manager#home-manager -- switch --flake "github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-aarch64"
```

### ローカル checkout を適用（`nix/` ディレクトリで実行）

### macOS

```bash
# ビルド
sudo nix run nix-darwin#darwin-rebuild -- build --flake .#Hoshiros-MacBook-Air

# 適用
sudo nix run nix-darwin#darwin-rebuild -- switch --flake .#Hoshiros-MacBook-Air
```

### Arch Linux

```bash
nix run home-manager#home-manager -- switch --flake .#hosshii@hosshiiarch
```

### devcontainer

```bash
# x86_64-linux
nix run home-manager#home-manager -- switch --flake .#vscode@devcontainer-x86_64

# aarch64-linux
nix run home-manager#home-manager -- switch --flake .#vscode@devcontainer-aarch64
```

### フォーマット

```bash
nix fmt
```

### macOS のエージェント通知

- macOS profile は Codex CLI / Claude Code の共通通知 backend に `terminal-notifier` を使う。Linux / devcontainer は `macos-remote` を使う。
- Codex CLI は応答完了時に通知する。本文は最後の応答を使い、本文がない場合も完了メッセージを表示する。
- デスクトップアプリは Settings → Notifications で応答完了通知と通知権限の要求を有効にする。
- macOS の「システム設定 → 通知」で、使用するアプリと `terminal-notifier` の通知を許可する。

設定適用後、`codex_notify.sh '{"type":"agent-turn-complete","last-assistant-message":"通知テスト"}'` で CLI 用フックを確認できる。CLI とアプリでそれぞれ応答を完了させ、通知が届くこととアプリの通知が重複しないことも確認する。

外部通知フックとアプリ設定の仕様は [OpenAI Docs: Notifications](https://learn.chatgpt.com/docs/config-file/config-advanced#notifications) と [Settings](https://learn.chatgpt.com/docs/reference/settings#notifications) を参照。

## エージェントのスキル

Codex と Claude Code の各モジュールは、[Matt Pocock のスキル](https://github.com/mattpocock/skills)から `grill-me` と依存する `grilling` を Home Manager で配置する。macOS・Arch Linux・devcontainer で共通のソースを使う。

- Codex: `$CODEX_HOME/skills/`（`~/.config/codex/skills/`）に配置。新しいセッションで `$grill-me` を呼び出す。
- Claude Code: `$CLAUDE_CONFIG_DIR/skills/`（`~/.config/claude-code/skills/`）に配置。新しいセッションで `/grill-me` を呼び出す。

Codex の `grill-me` は、`grilling/SKILL.md` を読んで実行する入口を Nix で生成する。Claude Code の入口と、両エージェントの質問手順 `grilling` は上流のまま使う。上流本文を置換しないため、通常の更新では Codex の入口を手動調整する必要はない。

Codex 向けにはスキルのディレクトリ全体をリンクする。`SKILL.md` 単体を Home Manager の `.text` で配置するとファイル自体がシンボリックリンクになり、Codex の探索で読み飛ばされるため、生成する入口にも `pkgs.writeTextDir` を使う。

取得元は `modules/home/dev/agent-skills/sources.nix` のコミットとハッシュで固定する。更新時は GitHub で対象コミットを確認し、`nix/` で以下を実行する。

```bash
nix store prefetch-file --unpack --json https://github.com/mattpocock/skills/archive/<commit>.tar.gz
```

取得定義の `rev` を対象コミット、`hash` を出力の `hash` に変更して、通常の適用コマンドを実行する。上流でディレクトリ構成や依存スキルが変わった場合は取得定義も見直す。スキルディレクトリには Nix store へのリンクが含まれるため、直接編集せず Nix 側で管理する。

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
