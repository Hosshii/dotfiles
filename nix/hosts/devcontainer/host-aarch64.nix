let
  username = "vscode";
in
{
  system = "aarch64-linux";
  hostname = "devcontainer-aarch64";
  inherit username;
  homedir = "/home/${username}";
}
