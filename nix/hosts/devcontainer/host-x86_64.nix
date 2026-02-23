let
  username = "vscode";
in
{
  system = "x86_64-linux";
  hostname = "devcontainer-x86_64";
  inherit username;
  homedir = "/home/${username}";
}
