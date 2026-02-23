{ inputs }:
let
  host = import ./host.nix;
  constants = import ../../lib/constants.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };
in
mkHost.mkHomeHost {
  inherit host constants;
  modules = [
    ./home.nix
  ];
}
