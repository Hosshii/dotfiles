# dotfiles

Nix (nix-darwin + home-manager) ベースのマルチプラットフォーム dotfiles 管理。

## Architecture

```
nix/          Nix 設定本体 (flake.nix がここにある)
├── lib/      共通ビルダー/定数
├── pkgs/     overlays 分類
├── modules/  モジュールライブラリ (darwin/home)
├── profiles/ モジュール組み合わせ定義
└── hosts/    ホスト別 metadata + profile 選択
devcontainer/ 他リポジトリ展開用テンプレート (.devcontainer + README)
script/       旧方式の補助スクリプト (現在は Nix 運用が主)
```

Nix 構成の詳細は以下を参照:

@import nix/README.md

## Key Commands

すべて `nix/` ディレクトリで実行する。

```bash
# macOS: 適用
sudo nix run nix-darwin -- switch --flake .

# Arch Linux: 適用
nix run home-manager -- switch --flake .#hosshii@hosshiiarch

# devcontainer: 適用
nix run home-manager -- switch --flake .#vscode@devcontainer-x86_64

# フォーマット (nixpkgs-fmt)
nix fmt
```

## Adding a New Module

1. `modules/home/<カテゴリ>/<ツール名>/default.nix` にモジュールを作成
2. 必要なら `modules/home/<カテゴリ>/default.nix` に追加
3. `profiles/*` へ組み込み、`hosts/<ホスト名>/home.nix` では profile を選択

## Important Conventions

- 各ツールは独立した `default.nix` として定義する
- `modules/` は部品、`profiles/` は組み合わせ、`hosts/` は選択のみを担う
- `pkgs/overlays/` は `features/*` で機能別に分割し、`system` 判定は `lib/mk-pkgs.nix` に集約する
- `hosts/<ホスト名>/host.nix` でホスト変数を定義し `extraSpecialArgs` で注入。`flake.nix` は薄いエントリポイント
- `_1password` の命名は維持する
- フォーマッタは `nixpkgs-fmt`

## Gotchas

- nix コマンドは必ず `nix/` ディレクトリで実行する（`flake.nix` がそこにある）
- `AGENTS.md` は `CLAUDE.md` への symlink
- `_1password` の命名は維持する（ディレクトリ名・オプション名）

## Devcontainer Template

他リポジトリに展開する最小テンプレートは以下:

- `devcontainer/`
