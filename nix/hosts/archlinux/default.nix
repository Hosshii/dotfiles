{ inputs }:
let
  system = "x86_64-linux";
  hostname = "hosshiiarch";
  username = "hosshii";
  homedir = "/home/${username}";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ inputs.claude-code-overlay.overlays.default ];
  };
in
{
  homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      hostConfig = { inherit username homedir; };
    };
    modules = [
      ./home.nix
    ];
  };

  formatter.${system} = pkgs.nixpkgs-fmt;
}
