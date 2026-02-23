{ inputs }:
let
  common = import ./common.nix { inherit inputs; };
  darwin = import ./darwin.nix { inherit inputs; };
  linux = import ./linux.nix { inherit inputs; };
in
{
  inherit common darwin linux;

  forSystem =
    system:
    let
      isDarwin = builtins.match ".*-darwin" system != null;
    in
    common ++ (if isDarwin then darwin else linux);
}
