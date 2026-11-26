{ inputs }:
let
  host = import ./host.nix;
  constants = import ../../lib/constants.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };
  macbook = mkHost.mkDarwinHost {
    inherit host constants;
    homeModule = import ./home.nix;
    darwinModules = [
      ../../profiles/base/darwin.nix
    ];
  };
  pkgs = macbook.darwinConfigurations.${host.hostname}.pkgs;
in
macbook
// {
  checks = macbook.checks // {
    ${host.system} = macbook.checks.${host.system} // {
      firefox-ja = import ../../modules/home/gui/firefox/package.nix { inherit pkgs; };
    };
  };
}
