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
  agentSkills = import ../agent-skills/sources.nix { inherit pkgs; };
  configFile = tomlFormat.generate "codex-config.toml" {
    model = "gpt-6.2-sol";
    model_reasoning_effort = "medium";
    notify = [ notifyScripts.codexNotifyPath ];
    project_doc_fallback_filenames = [ "CLAUDE.md" ];
    sandbox_mode = "workspace-write";
    approval_policy = "on-request";
    desktop = {
      show-context-window-usage = true;
    };
    features = {
      plugins = false;
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
  xdg.configFile = {
    "codex/skills/grilling".source = agentSkills.grilling;
    # Keep the Codex entry point independent of upstream's Claude Skill tool call.
    # Link the whole directory: Codex skips symlinked SKILL.md files.
    "codex/skills/grill-me".source = pkgs.writeTextDir "SKILL.md" ''
      ---
      name: grill-me
      description: A relentless interview to sharpen a plan or design.
      disable-model-invocation: true
      ---

      Read `${codexConfigDir}/skills/grilling/SKILL.md` and follow its instructions
      for the user's current plan, design, or idea.
    '';
  };

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
