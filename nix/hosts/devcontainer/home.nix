{ hostConfig, constants, ... }:
{
  imports = [
    ../../profiles/devcontainer/default.nix
  ];

  custom.git = {
    name = "Hosshii";
    email = "sao_heath6147.wistre@icloud.com";
  };

  home = {
    username = hostConfig.username;
    homeDirectory = hostConfig.homedir;
    stateVersion = constants.homeStateVersion;
  };
}
