{ inputs }:
let
  overlays = import ../pkgs/overlays { inherit inputs; };
in
{ system, allowUnfree ? true }:
import inputs.nixpkgs {
  inherit system;
  overlays = overlays.forSystem system;
  config.allowUnfree = allowUnfree;
}
