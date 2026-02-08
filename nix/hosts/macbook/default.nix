{ inputs }:
let
  system = "aarch64-darwin";
  hostname = "andouhanshirous-MacBook-Air";
  username = "andouhanshirou";
  homedir = "/Users/${username}";
  overlays = [
    inputs.brew-nix.overlays.default
    inputs.claude-code-overlay.overlays.default
  ];
  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
in
{
  darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.brew-nix.darwinModules.default
      { nixpkgs.overlays = overlays; }
      (import ../../darwin/default.nix { inherit system username pkgs homedir; self = inputs.self; brew-nix = inputs.brew-nix; })
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
