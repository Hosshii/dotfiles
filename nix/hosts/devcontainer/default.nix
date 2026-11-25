{ inputs }:
let
  inherit (inputs.nixpkgs.lib) recursiveUpdate;
  constants = import ../../lib/constants.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };

  mkDevcontainer =
    host:
    mkHost.mkHomeHost {
      inherit host constants;
      modules = [ ./home.nix ];
    };
in
recursiveUpdate (mkDevcontainer (import ./host-x86_64.nix)) (
  mkDevcontainer (import ./host-aarch64.nix)
)
