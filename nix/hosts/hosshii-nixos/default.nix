{ inputs }:
let
  host = import ./host.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };
in
mkHost.mkNixosHost {
  inherit host;
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../profiles/workstation/nixos.nix
  ];
}
