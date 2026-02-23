{ inputs }:
let
  base = import ./features/base.nix { inherit inputs; };
  ai = import ./features/ai.nix { inherit inputs; };
  brew = import ./features/brew.nix { inherit inputs; };
in
{
  all = base ++ ai;
  darwinOnly = brew;
  linuxOnly = [ ];
}
