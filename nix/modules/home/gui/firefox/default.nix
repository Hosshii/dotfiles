# mac にインストールする場合、デフォルトのパッケージだとfirefoxのバイナリがbash scriptになってしまい署名の検証が通らない。
# 1Password 拡張との連携に必要な署名を維持するため、macOS では brew-nix で Mozilla 配布のアプリを展開する。
{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home.packages = pkgs.lib.optionals isDarwin [
    (import ./package.nix { inherit pkgs; })
  ];

  programs.firefox = {
    enable = true;
    # Darwin: null にして wrap 処理をスキップ（home.packages で別途インストール）
    package = if isDarwin then null else pkgs.firefox;
    # languagePacks は package != null を要求するため Darwin では無効化
    languagePacks = pkgs.lib.optionals (!isDarwin) [ "ja" ];

    # 自動更新を無効化
    policies = {
      DisableAppUpdate = true;
    };

    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        # UIの言語を日本語に
        "intl.locale.requested" = "ja,en-US";
      };
    };
  };
}
