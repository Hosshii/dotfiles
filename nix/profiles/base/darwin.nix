{ pkgs, hostConfig, constants, self, ... }:
{
  environment.systemPackages = [
    pkgs.vim
    pkgs.defaultbrowser
  ];

  # installed via determinate
  nix.enable = false;

  brew-nix.enable = true;

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = constants.darwinStateVersion;
  };

  nixpkgs.hostPlatform = hostConfig.system;
  nixpkgs.config.allowUnfree = true;

  # home-manager の homeDirectory 解決に必要
  system.primaryUser = hostConfig.username;
  users.users.${hostConfig.username}.home = hostConfig.homedir;

  launchd.user.agents.set-default-browser = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.defaultbrowser}/bin/defaultbrowser"
        "firefox"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      ProcessType = "Background";
    };
  };

  imports = [
    ../../modules/darwin/_1password/default.nix
    ../../modules/darwin/zsh/default.nix
    (import ../../modules/darwin/defaults/default.nix { homedir = hostConfig.homedir; })
  ];
}
