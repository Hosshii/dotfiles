# devcontainer + Nix minimal template

`devShell` を単一ソースにしつつ、`postCreate` で dotfiles の `hosts/devcontainer` を適用する最小テンプレート。

## Files (このリポジトリ内)

- `devcontainer/.devcontainer/devcontainer.json`
- `devcontainer/.devcontainer/Dockerfile`
- `devcontainer/.devcontainer/postCreate.sh`
- `devcontainer/README.md`

## Design

- ベースイメージ: `mcr.microsoft.com/devcontainers/base:debian`
- Docker build 時に `vscode` ユーザーで Nix を導入
- `postCreate.sh` で `github:Hosshii/dotfiles?dir=nix` を参照して Home Manager を適用
- `uname -m` で以下を自動選択
  - `x86_64` -> `vscode@devcontainer-x86_64`
  - `aarch64` / `arm64` -> `vscode@devcontainer-aarch64`
- `postCreate.sh` の最後で `direnv allow` を実行
- 失敗時はフォールバックせず終了する

## Mounts / Cache

`devcontainer.json` では次を volume mount する。

- `/nix` -> `nix-store-${devcontainerId}`
- `~/.config/claude-code` -> `claude-code-config-${devcontainerId}`
- `~/.config/codex` -> `codex-config-${devcontainerId}`
- shell history (`/commandhistory`) -> `claude-code-bashhistory-${devcontainerId}`

`/nix` のキャッシュを削除したい場合:

```bash
docker volume rm <実際の volume 名>
```

## Usage

1. `devcontainer/.devcontainer/` の内容を対象リポジトリの `.devcontainer/` に配置
2. 対象リポジトリ側で `flake.nix` / `flake.lock` と `devShell` を用意
3. VS Code で `Reopen in Container`
4. 作成後に以下を確認

```bash
nix --version
git config --get user.name
git config --get user.email
```

## Manual re-apply

```bash
# x86_64
nix run github:nix-community/home-manager -- switch --flake 'github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-x86_64'

# aarch64 / arm64
nix run github:nix-community/home-manager -- switch --flake 'github:Hosshii/dotfiles?dir=nix#vscode@devcontainer-aarch64'
```

## dotfiles notes

- `hosts/devcontainer` は `host.identity.git` から `custom.git.name/email` を設定する
- 署名を使う場合は、コンテナ内で `SSH_AUTH_SOCK` が有効であることが前提
