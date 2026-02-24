{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.agentNotify;
  scripts = import ./scripts.nix {
    inherit pkgs;
    backend = cfg.backend;
  };
in
{
  options.custom.services.agentNotify = {
    backend = lib.mkOption {
      type = lib.types.enum [
        "macos-remote"
        "terminal-notifier"
      ];
      default = "macos-remote";
      description = "Backend used by agent-notify scripts.";
    };
  };

  config.home.packages = [
    scripts.claudeNotify
    scripts.claudeStop
    scripts.codexNotify
  ];
}
