{ hostConfig, ... }:
{
  imports = [
    ../../modules/home/cli
  ];

  custom.git = {
    name = hostConfig.identity.git.name;
    email = hostConfig.identity.git.email;
    ghq.enable = true;
    wt.enable = true;
    delta.enable = true;
  };
}
