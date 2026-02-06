{ inputs }:
let
  system = "x86_64-linux";
  hostname = "hosshiiarch";
  username = "hosshii";
  homedir = "/home/${username}";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      hostConfig = { inherit username homedir; };
    };
    modules = [
      ./home.nix
      { nixpkgs.config.allowUnfree = true; }
    ];
  };

  formatter.${system} = pkgs.nixpkgs-fmt;
}
