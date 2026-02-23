{ inputs }:
let
  overlaySets = import ../pkgs/overlays { inherit inputs; };
in
{ system, allowUnfree ? true }:
let
  isDarwin = builtins.match ".*-darwin" system != null;
  isLinux = builtins.match ".*-linux" system != null;
  osOverlays =
    if isDarwin then
      overlaySets.darwinOnly
    else if isLinux then
      overlaySets.linuxOnly
    else
      throw "Unsupported system for overlays: ${system}";
in
import inputs.nixpkgs {
  inherit system;
  overlays = overlaySets.all ++ osOverlays;
  config.allowUnfree = allowUnfree;
}
