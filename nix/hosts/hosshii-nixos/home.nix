{ constants, ... }:
{
  imports = [ ../../modules/home/cli/ripgrep/default.nix ];

  home.stateVersion = constants.homeStateVersion;
}
