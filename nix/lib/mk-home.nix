{ inputs }:
{ pkgs, hostConfig, constants, modules }:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs modules;
  extraSpecialArgs = {
    inherit hostConfig constants;
  };
}
