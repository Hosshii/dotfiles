# nix

NixOS、nix-darwin、Home Manager によるマルチプラットフォーム dotfiles 管理。

## 前提

- `--flake .#...` を使うコマンドは `nix/` ディレクトリで実行する
- `--flake "github:..."` を使うコマンドは任意ディレクトリで実行できる
- `flake.nix` は `nix/flake.nix` にある

## 対応ホスト

| ホスト | OS | 管理方式 |
|---|---|---|
| `Hoshiros-MacBook-Air` | macOS (`aarch64-darwin`) | nix-darwin + home-manager |
| `hosshii-nixos` | NixOS (`x86_64-linux`) | NixOS |
| `devcontainer-x86_64` | Linux (`x86_64-linux`) | standalone home-manager |
| `devcontainer-aarch64` | Linux (`aarch64-linux`) | standalone home-manager |

## flake outputs

`nix/flake.nix` が公開する主な outputs:

- `darwinConfigurations`
- `nixosConfigurations`
- `homeConfigurations`
- `homeManagerModules.devcontainer`
- `formatter`
- `checks`

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
    ├── hosshii-nixos/
    └── devcontainer/
```

## 設計ルール

- `modules/` は最小部品、`profiles/` は組み合わせ、`hosts/` は選択のみを担う
- `system` 判定は `lib/mk-pkgs.nix` に集約し、overlay 側に分散させない
- Git identity は `host.identity.git` を単一ソースとして使う
- `_1password` の命名は維持する
- Home Manager と nix-darwin の state version は `lib/constants.nix` で管理する
- NixOS の `system.stateVersion` は初回インストール時の値をホスト構成に保持する

## ホストごとの profile 構成

- macOS (`hosts/macbook/home.nix`)
  - `profiles/base/home.nix`
  - `profiles/workstation/macos.nix`
  - `hosts/macbook/ssh.nix`
- NixOS (`hosts/hosshii-nixos/default.nix`)
  - `profiles/workstation/nixos.nix`
  - ホスト固有の起動・ネットワーク・ユーザー設定とハードウェア設定
- devcontainer (`hosts/devcontainer/home.nix`)
  - `profiles/devcontainer/default.nix`
  - `custom.git.name` / `custom.git.email` は `host.identity.git` から注入

## 使い方

### GitHub リポジトリを直接参照して適用

```bash
# macOS
sudo nix run --refresh nix-darwin#darwin-rebuild -- switch --flake "github:Hosshii/dotfiles?dir=nix#Hoshiros-MacBook-Air"

# NixOS
sudo nixos-rebuild switch --flake "github:Hosshii/dotfiles?dir=nix#hosshii-nixos"

# devcontainer x86_64-linux
nix run --refresh home-manager#home-manager -- switch --flake "github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-x86_64"

# devcontainer aarch64-linux
nix run --refresh home-manager#home-manager -- switch --flake "github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-aarch64"
```

### ローカル checkout を適用（`nix/` ディレクトリで実行）

### NixOS

最初の切り替えは `hosshii-nixos` のローカルコンソールから行う。新規ファイルを含む変更は Git が認識できる状態にしてから実行する。

```bash
nixos-rebuild build --flake .#hosshii-nixos
sudo nixos-rebuild test --flake .#hosshii-nixos
```

`test` の後にローカルログイン、有線ネットワーク、`/` と `/boot` のマウントを確認する。

```bash
sudo nixos-rebuild switch --flake .#hosshii-nixos
```

再起動して同じ項目を確認する。

#### Mac から SSH で接続

`ssh nixos` は `hosshii-nixos.local` に接続する。NixOS が有線 LAN に mDNS で名前を公開するため、IP アドレスが変わっても同じ名前を使える。

Mac に nix-darwin の設定を適用し、NixOS が許可する公開鍵に対応した 1Password の SSH Key アイテムに `ssh://nixos` を一度だけ登録する。1Password が生成する SSH 設定を読み込む設定は Home Manager に含まれている。 [1Password SSH Bookmarks](https://www.1password.dev/ssh/bookmarks)

NixOS はシステム設定で宣言した公開鍵を認証に使う。鍵の追加と交換はホストの SSH 設定で行う。

初回接続では、NixOS のローカルコンソールで `ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub` を実行し、Mac に表示されるホスト鍵の指紋と照合する。

この接続では 1Password SSH エージェントを転送する。接続中は NixOS 上のプロセスが転送先のソケット経由で署名を要求できる。TCP と Unix ソケットの転送は、VS Code Remote SSH が使う Mac 側からのローカル転送に限定する。

### macOS

```bash
# ビルド
sudo nix run nix-darwin#darwin-rebuild -- build --flake .#Hoshiros-MacBook-Air

# 適用
sudo nix run nix-darwin#darwin-rebuild -- switch --flake .#Hoshiros-MacBook-Air
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

### 構成の評価チェック

`nix/` で以下を実行すると、CI と同じように NixOS、macOS、両アーキテクチャの devcontainer 構成を評価できる。

```bash
nix flake check --all-systems --no-build --keep-going --no-update-lock-file --no-accept-flake-config .
```

### macOS Firefox の更新

brew-nix が Mozilla 公式の日本語版 DMG を展開する。更新するには `nix/` で次のコマンドを実行する。スクリプトは Mozilla の安定版と日本語版 DMG の SHA-256 を取得し、新しい版があれば `modules/home/gui/firefox/source.json` を更新する。実行には `curl`、`jq`、`xxd` が必要。

```bash
bash modules/home/gui/firefox/update-source.sh
```

Apple Silicon の Mac でビルドし、Mozilla の署名とアプリのバージョンを確認してから、`source.json` の変更を手動で PR にする。

```bash
output=$(nix build --no-link --print-out-paths --no-update-lock-file --no-accept-flake-config .#checks.aarch64-darwin.firefox-ja)
app="$output/Applications/Firefox.app"
requirement='identifier "org.mozilla.firefox" and anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.6] exists and certificate leaf[field.1.2.840.113635.100.6.1.13] exists and certificate leaf[subject.OU] = "43AQ936H96"'
/usr/bin/codesign --verify --deep --strict --test-requirement="$requirement" "$app"
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")" = "$(jq -r '.version' modules/home/gui/firefox/source.json)"
```

切り替え後は日本語で表示され、Firefox の 1Password 拡張がデスクトップアプリに接続できることを実機で確認する。

### macOS のエージェント通知

- macOS profile は Codex CLI / Claude Code の共通通知 backend に `terminal-notifier` を使う。Linux / devcontainer は `localtools op-broker notify` を使う。
- Codex CLI は応答完了時に通知する。本文は最後の応答を使い、本文がない場合も完了メッセージを表示する。
- デスクトップアプリは Settings → Notifications で応答完了通知と通知権限の要求を有効にする。
- macOS の「システム設定 → 通知」で、使用するアプリと `terminal-notifier` の通知を許可する。

設定適用後、`codex_notify.sh '{"type":"agent-turn-complete","last-assistant-message":"通知テスト"}'` で CLI 用フックを確認できる。CLI とアプリでそれぞれ応答を完了させ、通知が届くこととアプリの通知が重複しないことも確認する。

外部通知フックとアプリ設定の仕様は [OpenAI Docs: Notifications](https://learn.chatgpt.com/docs/config-file/config-advanced#notifications) と [Settings](https://learn.chatgpt.com/docs/reference/settings#notifications) を参照。

## エージェントのスキル

Codex と Claude Code の各モジュールは、[Matt Pocock のスキル](https://github.com/mattpocock/skills)から `grill-me` と依存する `grilling` を Home Manager で配置する。macOS と devcontainer で共通のソースを使う。

- Codex: `$CODEX_HOME/skills/`（`~/.config/codex/skills/`）に配置。新しいセッションで `$grill-me` を呼び出す。
- Claude Code: `$CLAUDE_CONFIG_DIR/skills/`（`~/.config/claude-code/skills/`）に配置。新しいセッションで `/grill-me` を呼び出す。

Codex の `grill-me` は、`grilling/SKILL.md` を読んで実行する入口を Nix で生成する。Claude Code の入口と、両エージェントの質問手順 `grilling` は上流のまま使う。上流本文を置換しないため、通常の更新では Codex の入口を手動調整する必要はない。

Codex 向けにはスキルのディレクトリ全体をリンクする。`SKILL.md` 単体を Home Manager の `.text` で配置するとファイル自体がシンボリックリンクになり、Codex の探索で読み飛ばされるため、生成する入口にも `pkgs.writeTextDir` を使う。

取得元は `modules/home/dev/agent-skills/sources.nix` のコミットとハッシュで固定する。更新時は GitHub で対象コミットを確認し、`nix/` で以下を実行する。

```bash
nix store prefetch-file --unpack --json https://github.com/mattpocock/skills/archive/<commit>.tar.gz
```

取得定義の `rev` を対象コミット、`hash` を出力の `hash` に変更して、通常の適用コマンドを実行する。上流でディレクトリ構成や依存スキルが変わった場合は取得定義も見直す。スキルディレクトリには Nix store へのリンクが含まれるため、直接編集せず Nix 側で管理する。

## Starship の配色

`hosshii-nixos` は `hosts/hosshii-nixos/home.nix` で、暗い端末背景向けに彩度を抑えた `muted-dark` を選択する。テーマ指定を省略したホストでは、従来の配色 `terminal` が使われる。

選択したテーマの一部は、ホストの Home Manager 設定で上書きできる。

```nix
custom.starship = {
  theme = "muted-dark";
  colors.directory = "#829ab5";
};
```

テーマを追加するには `modules/home/cli/starship/themes.nix` に名前と色を定義し、ホストで `custom.starship.theme` にその名前を指定する。省略した項目には `terminal` の色が使われる。

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
