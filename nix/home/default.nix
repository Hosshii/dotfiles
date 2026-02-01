{ pkgs
, username
, homedir
, gitConfig
, onePasswordConfig
, ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${username}" = {
      imports = [
        (import ./core/default.nix { inherit gitConfig; })
        ./gui/default.nix
        ./_1password
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
        username = username;
        homeDirectory = homedir;
        # home-manager のステートバージョン
        stateVersion = "25.11";
      };
    };
  };
}
