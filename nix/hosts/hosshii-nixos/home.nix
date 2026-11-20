{ constants, ... }:
{
  imports = [ ../../profiles/workstation/nixos-home.nix ];

  home.stateVersion = constants.homeStateVersion;
}
