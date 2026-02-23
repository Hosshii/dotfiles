{ hostConfig, constants, ... }:
{
  imports = [
    ../../profiles/devcontainer/default.nix
  ];

  custom.git = {
    name = hostConfig.identity.git.name;
    email = hostConfig.identity.git.email;
  };

  home = {
    username = hostConfig.username;
    homeDirectory = hostConfig.homedir;
    stateVersion = constants.homeStateVersion;
  };
}
