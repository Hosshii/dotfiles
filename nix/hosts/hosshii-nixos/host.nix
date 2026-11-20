let
  identities = import ../../lib/identities.nix;
in
{
  system = "x86_64-linux";
  hostname = "hosshii-nixos";
  username = "hosshii";
  wiredInterface = "enp7s0";
  identity = identities.hosshii;
}
