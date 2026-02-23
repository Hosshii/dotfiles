{ ... }:
{
  imports = [
    ../../modules/home/gui
    ../../modules/home/dev
    ../../modules/home/services
    ../../modules/home/security
  ];

  custom.git.signing = {
    enable = true;
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlJMlA5F3n+RiT3Uml1RTx9RSO6A9Alw4/YQJDrLTEM";
  };

  programs._1password = {
    enable = true;
    cli.enable = false;
    gui.enable = false;
    sshIntegration.enable = true;
  };
}
