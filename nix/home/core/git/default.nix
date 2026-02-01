{ config, ... }:

{
  programs.git = {
    enable = true;

    includes = [
      { path = ./common_config; }
    ];

    settings = {
      user = {
        name = config.name;
        email = config.email;
      };
    };

    ignores = [
      "**/.claude/settings.local.json"
      "**/CLAUDE.local.md"
    ];
  };

  # delta（git pager）の設定
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side line-numbers decorations";
      whitespace-error-style = "22 reverse";
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
      };
    };
  };
}
