{ pkgs, username, homedir, gitConfig, ... }: {
  # これを設定しないと homeDirectory is nullみたいなエラーになる
  # https://github.com/nix-community/home-manager/issues/6743
  # https://github.com/nix-community/home-manager/issues/6557
  users.users.andouhanshirou.home = homedir;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${username}" = {
      imports = [
        (import ./core/default.nix { inherit gitConfig; })
        (import ./gui/default.nix { inherit gitConfig; })
      ];

      home = {
        username = username;
        homeDirectory = homedir;
        # home-manager のステートバージョン
        stateVersion = "25.11";

        packages = [
          pkgs.dust
          pkgs.fd
          pkgs.onefetch
          pkgs.sccache
          pkgs.tokei
          pkgs.tree
          pkgs.wget
        ];
      };
    };
  };
}
