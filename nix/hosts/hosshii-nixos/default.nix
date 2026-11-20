{ inputs }:
let
  host = import ./host.nix;
  constants = import ../../lib/constants.nix;
  mkHost = import ../../lib/mk-host.nix { inherit inputs; };
in
mkHost.mkNixosHost {
  inherit host;
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./ssh.nix
    ../../profiles/workstation/nixos.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          hostConfig = host;
          inherit constants;
        };
        users."${host.username}" = import ./home.nix;
      };
    }
  ];
}
