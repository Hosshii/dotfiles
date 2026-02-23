{ ... }:
{
  imports = [
    ../../modules/home/gui/alacritty/default.nix
    ../../modules/home/gui/fonts/default.nix
    ../../modules/home/dev/binutils/default.nix
    ../../modules/home/dev/claude-code/default.nix
    ../../modules/home/dev/cmake/default.nix
    ../../modules/home/dev/codex/default.nix
    ../../modules/home/dev/pstree/default.nix
    ../../modules/home/dev/time/default.nix
    ../../modules/home/services/agent-notify/default.nix
    ../../modules/home/services/macos-remote/default.nix
  ];
}
