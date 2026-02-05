{ lib, stdenv, fetchzip }:

let
  sources = lib.importJSON ./sources.json;
in
stdenv.mkDerivation {
  pname = "hammerspoon";
  version = sources.version;

  src = fetchzip {
    url = sources.url;
    sha256 = sources.sha256;
    stripRoot = false;
  };

  dontBuild = true;
  dontFixup = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r $src/Hammerspoon.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
