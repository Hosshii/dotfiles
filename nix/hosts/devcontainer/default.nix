{ inputs }:
let
  constants = import ../../lib/constants.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };

  hostX8664 = import ./host-x86_64.nix;
  hostAarch64 = import ./host-aarch64.nix;

  devcontainerX8664 = mkHost.mkHomeHost {
    host = hostX8664;
    inherit constants;
    modules = [
      ./home.nix
    ];
  };

  devcontainerAarch64 = mkHost.mkHomeHost {
    host = hostAarch64;
    inherit constants;
    modules = [
      ./home.nix
    ];
  };
in
devcontainerX8664 // devcontainerAarch64
