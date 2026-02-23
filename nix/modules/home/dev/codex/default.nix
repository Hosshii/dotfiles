{ pkgs, config, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  notifyScripts = import ../../services/agent-notify/scripts.nix { inherit pkgs; };
  configFile = tomlFormat.generate "codex-config.toml" {
    model = "gpt-5.3-codex";
    model_reasoning_effort = "xhigh";
    notify = [ notifyScripts.codexNotifyPath ];
    project_doc_fallback_filenames = [ "CLAUDE.md" ];
    mcp_servers = {
      context7 = {
        command = "pnpm";
        args = [
          "dlx"
          "@upstash/context7-mcp@2.1.1"
        ];
        startup_timeout_ms = 20000;
      };
    };

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
  home.packages = [
    pkgs.llm-agents.codex
    # 必要であればcoreなどに移動する
    pkgs.nodejs
    pkgs.pnpm
  ];

  xdg.configFile."codex/config.toml" = {
    source = configFile;
  };

  home.sessionVariables = {
    CODEX_HOME = "${config.xdg.configHome}/codex";
  };
}
