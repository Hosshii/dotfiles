{ pkgs, ... }:

let
  addons = import ./addons.nix { inherit (pkgs) lib stdenv fetchurl; };
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # brew-nix の Firefox は programs.firefox.package の wrap 処理と互換性がないため
  # home.packages で直接インストールする
  home.packages = pkgs.lib.optionals isDarwin [ pkgs.brewCasks.firefox ];

  programs.firefox = {
    enable = true;
    # Darwin: null にして wrap 処理をスキップ（home.packages で別途インストール）
    package = if isDarwin then null else pkgs.firefox;
    # languagePacks は package != null を要求するため Darwin では無効化
    languagePacks = pkgs.lib.optionals (!isDarwin) [ "ja" ];

    profiles.default = {
      id = 0;
      isDefault = true;
      extensions.packages = [ addons.onepassword ];
      settings = {
        # UIの言語を日本語に
        "intl.locale.requested" = "ja,en-US";
      };
    };
  };
}
