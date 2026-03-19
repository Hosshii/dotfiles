let
  identities = import ../../lib/identities.nix;
  username = "hosshii";
in
{
  system = "aarch64-darwin";
  hostname = "Hoshiros-MacBook-Air";
  inherit username;
  homedir = "/Users/${username}";
  identity = identities.hosshii;
}
