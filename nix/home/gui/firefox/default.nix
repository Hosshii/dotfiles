{ pkgs, ... }:

let
  addons = import ./addons.nix { inherit (pkgs) lib stdenv fetchurl; };
in
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "ja" ];

    profiles.alpha = {
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
