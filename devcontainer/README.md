# devcontainer + Nix minimal template

`devShell` を単一ソースにしつつ、`/nix` の named volume でローカルキャッシュを効かせる最小テンプレート。
`postCreate` で dotfiles の `hosts/devcontainer` 設定を自動適用する。

## Files

- `.devcontainer/devcontainer.json`
- `.devcontainer/Dockerfile`
- `.devcontainer/postCreate.sh`
- `flake.nix`
- `flake.lock`

## Design

- ベースイメージ: `mcr.microsoft.com/devcontainers/base:debian`
- Nix は Docker build 時に導入
- Nix installer: `sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon`
- Nix は `vscode` ユーザーで導入
- `flake-utils.lib.eachDefaultSystem` で system 固定を避ける
- `devShells.<system>.default` を使用
- `/nix` は `nix-store-v1` volume を共有
- VS Code terminal は `nix develop -c zsh` を既定に設定
- `postCreate.sh` で `github:Hosshii/dotfiles?dir=nix` を参照して Home Manager を適用
- `uname -m` で `vscode@devcontainer-x86_64` / `vscode@devcontainer-aarch64` を自動切り替え
- `nix develop` / Home Manager とも失敗時は失敗のまま停止（フォールバックしない）

## Usage

1. このテンプレートの全ファイルを対象リポジトリの root にコピー
2. `flake.nix` の `packages` をプロジェクト用に調整
3. VS Code で `Reopen in Container`
4. terminal で以下を確認

```bash
nix develop -c true
git --version
git config --get user.name
git config --get user.email
```

## Home Manager target

- `x86_64` -> `vscode@devcontainer-x86_64`
- `aarch64` / `arm64` -> `vscode@devcontainer-aarch64`

## Manual re-apply

```bash
# x86_64
nix run github:nix-community/home-manager -- switch --flake 'github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-x86_64'

# aarch64 / arm64
nix run github:nix-community/home-manager -- switch --flake 'github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-aarch64'
```

## dotfiles notes

- Home Manager 設定は `github:Hosshii/dotfiles?dir=nix` から取得するため、`postCreate` 時にネットワーク接続が必要
- `custom.git.*` などの値は dotfiles 側 `hosts/devcontainer` 定義が適用される
- 署名を有効化する場合は、コンテナ内で `SSH_AUTH_SOCK` が有効であることが前提

AI 設定を永続化する mount 例:

```json
"mounts": [
  {
    "source": "claude-code-config-${devcontainerId}",
    "target": "/home/vscode/.config/claude-code",
    "type": "volume"
  },
  {
    "source": "codex-config-${devcontainerId}",
    "target": "/home/vscode/.config/codex",
    "type": "volume"
  }
]
```

## Cache operation

- 全プロジェクトで同じ volume 名 `nix-store-v1` を使う
- キャッシュ破損時だけ volume を削除

```bash
docker volume rm nix-store-v1
```

- 大きな更新で切り替える場合は `nix-store-v2` のように version を上げる

## Per-project overrides

`containerUser` は既定で `vscode`。必要なら各プロジェクトで上書きする。
