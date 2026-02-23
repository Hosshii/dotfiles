{ pkgs, ... }:
let
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  home.packages = [
    scripts.claudeNotify
    scripts.claudeStop
    scripts.codexNotify
  ];
}
