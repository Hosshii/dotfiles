{
  pkgs,
  config,
  lib,
  llmAgentsPkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  backend = lib.attrByPath [ "custom" "services" "agentNotify" "backend" ] "macos-remote" config;
  notifyScripts = import ../../services/agent-notify/scripts.nix {
    inherit pkgs backend;
  };
  codexConfigDir = "${config.xdg.configHome}/codex";
  configFile = tomlFormat.generate "codex-config.toml" {
    model = "gpt-6.1-sol";
    model_reasoning_effort = "medium";
    notify = [ notifyScripts.codexNotifyPath ];
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    projects = {
      "/workspace" = {
        trust_level = "trusted";
      };
    };

    tui = {
      status_line = [
        "model-name"
        "model-with-reasoning"
        "current-dir"
        "context-used"
        "five-hour-limit"
      ];
    };
  };
in
{
  home = {
    packages = [
      llmAgentsPkgs.codex
    ];

    activation.writeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${codexConfigDir}"
      cp --no-preserve=mode,ownership ${configFile} "${codexConfigDir}/config.toml"
      chmod 644 "${codexConfigDir}/config.toml"
    '';

    sessionVariables = {
      CODEX_HOME = "${config.xdg.configHome}/codex";
    };
  };
}
