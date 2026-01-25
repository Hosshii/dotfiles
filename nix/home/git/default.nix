{ config, ... }: {
  enable = true;
  includes = [
    { path = ./common_config; }
  ];

  settings = {
    gpg.format = "ssh";
    commit.gpgsign = true;

    user = {
      name = config.name;
      email = config.email;
      signingKey = config.signingKey;
    };
    "gpg \"ssh\"".program = config.sshProgram;
  };

  ignores = [
    "**/.claude/settings.local.json"
    "**/CLAUDE.local.md"
  ];
}
