{ config, lib, pkgs, ... }:
let
  cfg = config.custom.git;
in
{
  options.custom.git = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Git user name";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Git user email";
    };
    wt = {
      enable = lib.mkEnableOption "git-wt (worktree helper)";
    };
    ghq = {
      enable = lib.mkEnableOption "ghq (repository manager)";
    };
    delta = {
      enable = lib.mkEnableOption "delta (git pager)";
    };
  };

  config = lib.mkMerge [
    {
      programs.git = {
        enable = true;

        includes = [
          { path = ./common_config; }
        ];

        settings = {
          user = {
            name = cfg.name;
            email = cfg.email;
          };
        };

        ignores = [
          "**/.claude/settings.local.json"
          "**/CLAUDE.local.md"
        ];
      };
    }
    (lib.mkIf cfg.delta.enable {
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
    })
    (lib.mkIf cfg.wt.enable {
      home.packages = [ pkgs.git-wt ];
      programs.git.includes = [{ path = ./wt_config; }];
    })
    (lib.mkIf cfg.ghq.enable {
      home.packages = [ pkgs.ghq ];
      programs.git.includes = [{ path = ./ghq_config; }];
    })
  ];
}
