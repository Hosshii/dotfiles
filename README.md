# dotfiles

Nix (`nix-darwin` + `home-manager`) ベースのマルチプラットフォーム dotfiles 管理。

## Repository Layout

- `nix/`: Nix 設定本体（`flake.nix`、modules/profiles/hosts）
- `devcontainer/`: 他リポジトリ展開用の最小 devcontainer テンプレート
- `script/`: 旧方式の補助スクリプト

## Quick Start

すべて `nix/` ディレクトリで実行する。

```bash
# macOS
sudo nix run nix-darwin -- switch --flake .

# Arch Linux
nix run home-manager -- switch --flake .#hosshii@hosshiiarch

# devcontainer (x86_64)
nix run home-manager -- switch --flake .#vscode@devcontainer-x86_64

# format
nix fmt
```

## Documentation

- Nix 構成の詳細: [nix/README.md](nix/README.md)
- devcontainer テンプレート詳細: [devcontainer/README.md](devcontainer/README.md)
- エージェント向け運用メモ: [CLAUDE.md](CLAUDE.md)

## Notes

- `AGENTS.md` は `CLAUDE.md` への symlink
- `_1password` の命名は維持する
