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
      nixpkgs.overlays = import ../../pkgs/overlays/features/ai.nix { inherit inputs; };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          hostConfig = host;
          inherit constants;
          llmAgentsPkgs = inputs.llm-agents.packages.${host.system};
        };
        users."${host.username}" = import ./home.nix;
      };
    }
  ];
}
