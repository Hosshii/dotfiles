{ pkgs, config, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  configFile = tomlFormat.generate "codex-config.toml" {
    model = "gpt-5.3-codex";
    model_reasoning_effort = "xhigh";
    notify = [ "claude_notify.sh" ];
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    projects = {
      "/workspace" = {
        trust_level = "trusted";
      };
    };

    notice = {
      model_migrations = {
        "gpt-5.2-codex" = "gpt-5.3-codex";
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
  home.packages = [ pkgs.llm-agents.codex ];

  xdg.configFile."codex/config.toml" = {
    source = configFile;
  };

  home.sessionVariables = {
    CODEX_HOME = "${config.xdg.configHome}/codex";
  };
}
