# devcontainer + Nix minimal template

`devShell` を単一ソースにしつつ、`/nix` の named volume でローカルキャッシュを効かせる最小テンプレート。

## Files

- `.devcontainer/devcontainer.json`
- `.devcontainer/Dockerfile`
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
- `nix develop` 失敗時は失敗のまま停止（フォールバックしない）

## Usage

1. このテンプレートの全ファイルを対象リポジトリの root にコピー
2. `flake.nix` の `packages` をプロジェクト用に調整
3. VS Code で `Reopen in Container`
4. terminal で以下を確認

```bash
nix flake show
nix develop -c true
git --version
```

## Git SSH signing (dotfiles module)

`dotfiles.homeManagerModules.devcontainer` を使う場合は、利用側で以下を設定する。

- `custom.git.name`
- `custom.git.email`
- `custom.git.signing.enable = true`（必要な場合）
- `custom.git.signing.publicKey`（必要な場合）

署名を有効にする場合、コンテナ内で `SSH_AUTH_SOCK` が有効であることが前提。

## dotfiles devcontainer profile notes

- `dotfiles.homeManagerModules.devcontainer` は `git` / `delta` / `git-wt` / `zsh` / `claude-code` / `codex` を提供する
- 外部 flake で利用する場合は `pkgs` 生成時に `dotfiles.overlays.forSystem <system>` を適用する
- `custom.git.name` / `custom.git.email` は必須
- `rust` / `node` / `protoc` / `mise` の toolchain は `devShell` 側で管理する
- `CLAUDE_CONFIG_DIR` / `CODEX_HOME` は XDG (`~/.config/claude-code`, `~/.config/codex`) を使う

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
