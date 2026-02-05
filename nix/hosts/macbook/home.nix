{ username, homedir, gitConfig, onePasswordConfig }:
{
  imports = [
    (import ../../home/core { inherit gitConfig; })
    ../../home/gui
    ../../home/opt
    ../../home/_1password
    ./ssh.nix
  ];

  programs._1password = {
    enable = onePasswordConfig.enable;
    cli.enable = onePasswordConfig.cli.enable;
    gui.enable = onePasswordConfig.gui.enable;
    sshIntegration.enable = onePasswordConfig.sshIntegration.enable;
    gitSignIntegration = {
      enable = onePasswordConfig.gitSignIntegration.enable;
      signingKey = onePasswordConfig.gitSignIntegration.signingKey;
    };
  };

  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";
  };
}
