{ pkgs, config, lib, ... }:
let
  jsonFormat = pkgs.formats.json { };
  backend = lib.attrByPath [ "custom" "services" "agentNotify" "backend" ] "macos-remote" config;
  notifyScripts = import ../../services/agent-notify/scripts.nix {
    inherit pkgs backend;
  };
  claudeStatusline = pkgs.writeShellScriptBin "claude-statusline" ''
    #!/bin/bash

    # Read JSON input from stdin
    input=$(cat)

    # Extract values from JSON
    cwd=$(echo "$input" | jq -r '.workspace.current_dir')
    model=$(echo "$input" | jq -r '.model.display_name')
    used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
    project_dir=$(echo "$input" | jq -r '.workspace.project_dir')

    # Get git branch (skip optional locks)
    if [ -n "$project_dir" ] && [ -d "$project_dir/.git" ]; then
      branch=$(cd "$project_dir" && git -c core.fileMode=false symbolic-ref --short HEAD 2>/dev/null || git -c core.fileMode=false rev-parse --short HEAD 2>/dev/null)
    else
      branch=""
    fi

    # Build status line
    status=""

    # Add directory
    if [ -n "$cwd" ]; then
      status="$status$cwd"
    fi

    # Add model
    if [ -n "$model" ]; then
      [ -n "$status" ] && status="$status | "
      status="$status$model"
    fi

    # Add context usage
    if [ -n "$used_pct" ]; then
      [ -n "$status" ] && status="$status | "
      status="''${status}Context: ''${used_pct}%"
    fi

    # Add git branch
    if [ -n "$branch" ]; then
      [ -n "$status" ] && status="$status | "
      status="$status git:$branch"
    fi

    echo "$status"
  '';
  settingsFile = jsonFormat.generate "claude-code-settings.json" {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    language = "japanese";
    plansDirectory = "./plans";
    statusLine = {
      type = "command";
      command = "${claudeStatusline}/bin/claude-statusline";
    };
    hooks = {
      Notification = [
        {
          hooks = [
            {
              type = "command";
              command = notifyScripts.claudeNotifyPath;
            }
          ];
        }
      ];
      Stop = [
        {
          hooks = [
            {
              type = "command";
              command = notifyScripts.claudeStopPath;
            }
          ];
        }
      ];
    };
    env = { };
    enabledPlugins = {
      "feature-dev@claude-plugins-official" = true;
      "context7@claude-plugins-official" = true;
      "commit-commands@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
    };
    permissions = {
      allow = [
        "Write(src/**)"
        "Write(docs/**)"
        "Write(.tmp/**)"
        "Bash(git add:*)"
        "Bash(git commit:*)"
        "Bash(git status:*)"
        "Bash(git diff:*)"
        "Bash(git log:*)"
        "Bash(ls:*)"
        "Bash(cat **)"
        "mcp__context7__resolve-library-id"
        "mcp__context7__get-library-docs"
      ];
      deny = [
        "Bash(sudo:*)"
        "Bash(rm -rf:*)"
        "Bash(git push:*)"
        "Bash(git reset:*)"
        "Bash(git rebase:*)"
        "Read(.env.*)"
        "Read(id_rsa)"
        "Read(id_ed25519)"
        "Write(.env*)"
        "Bash(curl:*)"
        "Bash(wget:*)"
      ];
    };
  };
in
{
  home.packages = [ pkgs.claude-code ];

  xdg.configFile."claude-code/settings.json".source = settingsFile;

  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude-code";
  };
}
