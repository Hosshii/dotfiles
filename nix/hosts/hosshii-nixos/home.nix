{ constants, hostConfig, ... }:
{
  imports = [ ../../profiles/workstation/nixos-home.nix ];

  home.stateVersion = constants.homeStateVersion;

  custom.starship.theme = "muted-dark";

  custom.git.signing = {
    enable = true;
    publicKey = hostConfig.identity.git.signingPublicKey;
  };
}
