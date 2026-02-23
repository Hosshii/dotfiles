{ hostConfig, constants, ... }:
{
  imports = [
    ../../profiles/base/home.nix
    ../../profiles/workstation/linux.nix
  ];

  home = {
    username = hostConfig.username;
    homeDirectory = hostConfig.homedir;
    stateVersion = constants.homeStateVersion;
  };
}
