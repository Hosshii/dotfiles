# Firefox拡張機能パッケージ定義
#
# NURを使わずに自前でFirefox拡張機能をパッケージ化するモジュール。
# AMO (addons.mozilla.org) からXPIファイルをダウンロードしてインストールする。
#
# 新しい拡張機能を追加する手順:
# 1. AMO APIでスラッグからaddonId、バージョン、XPI URLを取得:
#    curl -s "https://addons.mozilla.org/api/v5/addons/addon/<slug>/" | jq -r '.guid, .current_version.version, .current_version.file.url'
#
# 2. ハッシュ値を計算:
#    nix-prefetch-url "<XPI_URL>"
#
# 3. このファイルにbuildFirefoxXpiAddonで新しいパッケージを定義
{ lib, stdenv, fetchurl }:

let
  # Firefox拡張機能(XPI)をビルドするヘルパー関数
  #
  # 引数:
  #   pname   - パッケージ名
  #   version - 拡張機能のバージョン
  #   addonId - 拡張機能の一意識別子 (AMO APIの.guidフィールド)
  #   url     - XPIファイルのダウンロードURL
  #   sha256  - XPIファイルのハッシュ値
  #   meta    - オプションのメタデータ
  buildFirefoxXpiAddon =
    { pname
    , version
    , addonId
    , url
    , sha256
    , meta ? { }
    ,
    }:
    stdenv.mkDerivation {
      inherit pname version;
      src = fetchurl { inherit url sha256; };
      preferLocalBuild = true;
      allowSubstitutes = true;
      # addonIdをpassthruに保存し、他のNix式から参照可能にする
      passthru = { inherit addonId; };
      # XPIファイルをFirefoxの拡張機能ディレクトリにインストール
      # {ec8030f7-c20a-464f-9b0e-13a3a9e97384} はFirefoxのアプリケーションID
      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';

      meta = with lib; {
        platforms = platforms.all;

        mozPermissions = [
          "<all_urls>"
          "alarms"
          "clipboardWrite"
          "contextMenus"
          "downloads"
          "idle"
          "management"
          "nativeMessaging"
          "notifications"
          "privacy"
          "scripting"
          "storage"
          "tabs"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "declarativeNetRequestWithHostAccess"
          "https://*/*"
          "http://localhost/*"
          "https://*.1password.ca/*"
          "https://*.1password.com/*"
          "https://*.1password.eu/*"
          "https://*.b5dev.ca/*"
          "https://*.b5dev.com/*"
          "https://*.b5dev.eu/*"
          "https://*.b5local.com/*"
          "https://*.b5staging.com/*"
          "https://*.b5test.ca/*"
          "https://*.b5test.com/*"
          "https://*.b5test.eu/*"
          "https://*.b5rev.com/*"
          "https://app.kolide.com/*"
          "https://auth.kolide.com/*"
          "https://www.director.ai/?*"
          "https://www.director.ai/"
          "https://www.director.ai/complete-1password-pairing?*"
          "https://www.director.ai/complete-1password-pairing"
          "https://autofill.me/*"
        ];
      } // meta;
    };
in
{
  # buildFirefoxXpiAddon関数をエクスポート（外部から新しい拡張機能を定義する場合に使用）
  inherit buildFirefoxXpiAddon;

  # 1Password - パスワードマネージャー
  # https://addons.mozilla.org/firefox/addon/1password-x-password-manager/
  onepassword = buildFirefoxXpiAddon {
    pname = "1password";
    version = "8.11.27.2";
    addonId = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4654028/1password_x_password_manager-8.11.27.2.xpi";
    sha256 = "sha256-p9tpiOTQLf6cFRPfUhqI8IJR5aimgxVb2aVhn1DyH74=";
    meta.description = "1Password password manager";
  };
}
