{ pkgs }:

let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
pkgs.brewCasks.firefox.overrideAttrs {
  inherit (source) version;
  src = pkgs.fetchurl {
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${source.version}/mac/ja-JP-mac/Firefox%20${source.version}.dmg";
    inherit (source) hash;
  };

  # Leave the signed application bundle untouched.
  dontFixup = true;
}
