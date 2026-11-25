{ hostConfig, ... }:
{
  imports = [
    ../../modules/home/cli/localtools/default.nix
    ../../modules/home/gui
    ../../modules/home/dev
    ../../modules/home/services
    ../../modules/home/security
  ];

  custom.services.agentNotify.backend = "terminal-notifier";

  custom.git.signing = {
    enable = true;
    publicKey = hostConfig.identity.git.signingPublicKey;
  };

  programs._1password = {
    enable = true;
    cli.enable = false;
    gui.enable = false;
    sshIntegration.enable = true;
  };
}
