let
  username = "andouhanshirou";
in
{
  system = "aarch64-darwin";
  hostname = "andouhanshirous-MacBook-Air";
  inherit username;
  homedir = "/Users/${username}";
}
