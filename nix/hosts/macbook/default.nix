{ inputs }:
let
  system = "aarch64-darwin";
  hostname = "andouhanshirous-MacBook-Air";
  username = "andouhanshirou";
  homedir = "/Users/${username}";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      (import ../../darwin/default.nix { inherit system username pkgs homedir; self = inputs.self; })
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            hostConfig = { inherit username homedir; };
          };
          users."${username}" = import ./home.nix;
        };
      }
    ];
  };

  formatter.${system} = pkgs.nixpkgs-fmt;
}
