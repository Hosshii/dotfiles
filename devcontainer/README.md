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

## Cache operation

- 全プロジェクトで同じ volume 名 `nix-store-v1` を使う
- キャッシュ破損時だけ volume を削除

```bash
docker volume rm nix-store-v1
```

- 大きな更新で切り替える場合は `nix-store-v2` のように version を上げる

## Per-project overrides

`containerUser` は既定で `vscode`。必要なら各プロジェクトで上書きする。
