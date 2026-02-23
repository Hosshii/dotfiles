{ pkgs, config, ... }:
let
  jsonFormat = pkgs.formats.json { };
  notifyScripts = import ../../services/agent-notify/scripts.nix { inherit pkgs; };
  settingsFile = jsonFormat.generate "claude-code-settings.json" {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    language = "japanese";
    plansDirectory = "./plans";
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
