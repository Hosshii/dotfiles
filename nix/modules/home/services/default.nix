{ ... }:
{
  imports = [
    ./agent-notify/default.nix
    ./docker-client/default.nix
    ./docker-desktop/default.nix
    ./macos-remote/default.nix
    ./terminal-notifier/default.nix
  ];
}
