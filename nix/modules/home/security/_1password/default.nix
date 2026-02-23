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

    sshIntegration.enable = lib.mkEnableOption "1Password SSH agent integration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.optionals cfg.cli.enable [ pkgs._1password-cli ]
      ++ lib.optionals cfg.gui.enable [ pkgs._1password-gui ];

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
