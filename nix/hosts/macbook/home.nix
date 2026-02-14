{ hostConfig, ... }:
{
  imports = [
    ../../home/core
    ../../home/gui
    ../../home/opt
    ../../home/_1password
    ./ssh.nix
  ];

  custom.git = {
    name = "Hosshii";
    email = "sao_heath6147.wistre@icloud.com";
    ghq.enable = true;
    wt.enable = true;
    delta.enable = true;
  };

  programs._1password = {
    enable = true;
    cli.enable = false;
    gui.enable = false;
    sshIntegration.enable = true;
    gitSignIntegration = {
      enable = true;
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlJMlA5F3n+RiT3Uml1RTx9RSO6A9Alw4/YQJDrLTEM";
    };
  };

  home = {
    username = hostConfig.username;
    homeDirectory = hostConfig.homedir;
    stateVersion = "25.11";
  };
}
