# dotfiles

Nix (nix-darwin + home-manager) ベースのマルチプラットフォーム dotfiles 管理。

## Architecture

```
nix/          Nix 設定本体 (flake.nix がここにある)
├── darwin/   macOS システムレベル設定 (nix-darwin)
├── home/     home-manager モジュールライブラリ
│   ├── core/ CLI ツール (全ホスト共通)
│   ├── gui/  GUI アプリ (ホスト依存)
│   └── opt/  オプションツール (ホスト依存)
└── hosts/    ホスト別モジュール選択
config/       Nix 管理外の設定ファイル
```

Nix 構成の詳細は以下を参照:

@import nix/README.md

## Key Commands

すべて `nix/` ディレクトリで実行する。

```bash
# macOS: ビルド & 適用
sudo nix run nix-darwin -- switch --flake .

# Arch Linux: 適用
nix run home-manager -- switch --flake .#hosshii@hosshiiarch

# フォーマット (nixpkgs-fmt)
nix fmt
```

## Adding a New Module

1. `home/<カテゴリ>/<ツール名>/default.nix` にモジュールを作成
2. 全ホスト共通なら集約 `default.nix` (`home/core/default.nix` 等) に追加
3. 特定ホストのみなら `hosts/<ホスト名>/home.nix` の imports に直接追加

## Important Conventions

- 各ツールは独立した `default.nix` として定義する
- `home/core/` は全ホスト共通、`home/gui/` と `home/opt/` はホスト依存
- `hosts/<ホスト名>/home.nix` でモジュール選択を制御
- `hosts/<ホスト名>/default.nix` でホスト変数（ユーザー名、ホームディレクトリ等）を定義し `extraSpecialArgs` で注入。`flake.nix` は薄いエントリポイント
- フォーマッタは `nixpkgs-fmt`

## Gotchas

- nix コマンドは必ず `nix/` ディレクトリで実行する（`flake.nix` がそこにある）
- レガシーの `install.sh`、`script/`、`config/` は旧インストール方式（rhysd/dotfiles ベース）
- `nix2/` は実験的ディレクトリで使用しない

## Devcontainer Template

他リポジトリに展開する最小テンプレートは以下:

- `templates/devcontainer-nix-minimal/`
