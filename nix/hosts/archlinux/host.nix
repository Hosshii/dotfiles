let
  username = "hosshii";
in
{
  system = "x86_64-linux";
  hostname = "hosshiiarch";
  inherit username;
  homedir = "/home/${username}";
}
