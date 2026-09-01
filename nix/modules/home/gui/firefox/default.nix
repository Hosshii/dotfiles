# mac にインストールする場合、デフォルトのパッケージだとfirefoxのバイナリがbash scriptになってしまい署名の検証が通らない。
# その結果1password拡張とdesktop appの通信ができないため、brew-nix経由でバイナリを入れることで解決する
{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # brew-nix の Firefox は programs.firefox.package の wrap 処理と互換性がないため
  # home.packages で直接インストールする
  home.packages = pkgs.lib.optionals isDarwin [
    # brewのfirefox-jaをinstallするためにoverride
    (pkgs.brewCasks.firefox.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${oldAttrs.version}/mac/ja-JP-mac/Firefox%20${oldAttrs.version}.dmg";
        # echo <brewのsha> \
        # | xxd -r -p \
        # | base64
        hash = "sha256-x1vEZ8xmsDbSmvvaxWZ/MfTIiWReP4X3KT+shKdPcBE=";
      };
    }))
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
