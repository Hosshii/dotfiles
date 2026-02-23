{ config, lib, pkgs, ... }:

let
  cfg = config.programs._1password;

  sshAuthSock =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  options.programs._1password = {
    enable = lib.mkEnableOption "1Password integration";

    cli.enable = lib.mkEnableOption "1Password CLI";

    gui.enable = lib.mkEnableOption "1Password GUI application";

    gitSignIntegration = {
      enable = lib.mkEnableOption "Git commit signing with 1Password SSH key";

      signingKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "SSH public key for Git commit signing";
      };
    };

    sshIntegration.enable = lib.mkEnableOption "1Password SSH agent integration";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.gitSignIntegration.enable -> cfg.gitSignIntegration.signingKey != "";
        message = "programs._1password.gitSignIntegration.signingKey must be set when gitSignIntegration is enabled";
      }
    ];

    home.packages = lib.optionals cfg.cli.enable [ pkgs._1password-cli ]
      ++ lib.optionals cfg.gui.enable [ pkgs._1password-gui ];

    programs.git = lib.mkIf cfg.gitSignIntegration.enable {
      settings = {
        user.signingKey = cfg.gitSignIntegration.signingKey;
        gpg.format = "ssh";
        commit.gpgSign = true;
      };
    };

    programs.ssh = lib.mkIf cfg.sshIntegration.enable {
      enable = true;
      includes = [ "~/.ssh/1Password/config" ];

      matchBlocks = {
        "arch" = {
          identityAgent = [
            ''"${sshAuthSock}"''
          ];
        };
      };
    };

    programs.zsh.sessionVariables = lib.mkIf cfg.sshIntegration.enable {
      SSH_AUTH_SOCK = sshAuthSock;
    };
  };
}
