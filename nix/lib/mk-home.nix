{ inputs }:
{
  pkgs,
  hostConfig,
  constants,
  modules,
  llmAgentsPkgs,
}:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs modules;
  extraSpecialArgs = {
    inherit hostConfig constants llmAgentsPkgs;
  };
}
