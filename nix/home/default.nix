{ pkgs, username, homedir, gitConfig, ... }: {
  # これを設定しないと homeDirectory is nullみたいなエラーになる
  # https://github.com/nix-community/home-manager/issues/6743
  # https://github.com/nix-community/home-manager/issues/6557
  users.users.andouhanshirou.home = homedir;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${username}" = {
      home = {
        username = username;
        homeDirectory = homedir;
        # home-manager のステートバージョン
        stateVersion = "25.11";

        packages = [
          pkgs.bat
        ];
      };

      programs = {
        bat = {
          enable = true;
          config = {
            theme = "Solarized (light)";
          };
        };

        git = import ./git/default.nix {
          config = gitConfig;
        };
      };
    };
  };
}
