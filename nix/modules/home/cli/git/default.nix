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
    signing = {
      enable = lib.mkEnableOption "Git commit signing with SSH key";

      publicKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "SSH public key for Git commit signing";
      };
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
      assertions = [
        {
          assertion = cfg.signing.enable -> cfg.signing.publicKey != "";
          message = "custom.git.signing.publicKey must be set when custom.git.signing.enable is true";
        }
      ];

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
    (lib.mkIf cfg.signing.enable {
      programs.git.settings = {
        user.signingKey = cfg.signing.publicKey;
        gpg.format = "ssh";
        commit.gpgSign = true;
      };
    })
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
