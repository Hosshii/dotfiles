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

1. `modules/home/<カテゴリ>/<ツール名>/default.nix` にモジュールを作成
2. 必要なら `modules/home/<カテゴリ>/default.nix` に追加
3. `profiles/*` へ組み込み、`hosts/<ホスト名>/home.nix` では profile を選択

## Important Conventions

- 各ツールは独立した `default.nix` として定義する
- `modules/` は部品、`profiles/` は組み合わせ、`hosts/` は選択のみを担う
- `pkgs/overlays/` は `common` / `darwin` / `linux` で分類する
- `hosts/<ホスト名>/host.nix` でホスト変数を定義し `extraSpecialArgs` で注入。`flake.nix` は薄いエントリポイント
- `_1password` の命名は維持する
- フォーマッタは `nixpkgs-fmt`

## Gotchas

- nix コマンドは必ず `nix/` ディレクトリで実行する（`flake.nix` がそこにある）
- レガシーの `install.sh`、`script/`、`config/` は旧インストール方式（rhysd/dotfiles ベース）
- `nix2/` は実験的ディレクトリで使用しない

## Devcontainer Template

他リポジトリに展開する最小テンプレートは以下:

- `templates/devcontainer-nix-minimal/`
