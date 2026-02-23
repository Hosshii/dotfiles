{ inputs }:
let
  host = import ./host.nix;
  constants = import ../../lib/constants.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };
in
mkHost.mkDarwinHost {
  inherit host constants;
  homeModule = import ./home.nix;
  darwinModules = [
    ../../profiles/base/darwin.nix
  ];
}
