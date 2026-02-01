{
  description = "dotfiles managed with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nix-darwin
    , home-manager
    ,
    }:
    let
      # システムアーキテクチャ（Apple Silicon）
      system = "aarch64-darwin";
      hostname = "andouhanshirous-MacBook-Air";
      username = "andouhanshirou";
      homedir = /Users/${username};

      # Git用（name/emailのみ）
      gitConfig = {
        name = "Hosshii";
        email = "sao_heath6147.wistre@icloud.com";
      };

      # 1Password用
      onePasswordConfig = {
        enable = true;
        # mac だと nix darwinで入れないとうまく動かないので無効化
        cli.enable = false;
        gui.enable = false;
        sshIntegration.enable = true;
        gitSignIntegration = {
          enable = true;
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlJMlA5F3n+RiT3Uml1RTx9RSO6A9Alw4/YQJDrLTEM";
        };
      };

      # arch用（将来）
      # onePasswordConfigArch = {
      #   enable = true;
      #   cli.enable = false;
      #   gui.enable = false;
      #   sshIntegration.enable = true;  # SSH forwarding経由
      #   gitSignIntegration = {
      #     enable = true;
      #     signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlJMlA5F3n+RiT3Uml1RTx9RSO6A9Alw4/YQJDrLTEM";
      #   };
      # };

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        modules = [
          (import ./darwin/default.nix { inherit system pkgs homedir self; })
          ./darwin/_1password/default.nix
          home-manager.darwinModules.home-manager
          (import ./home/default.nix {
            inherit
              pkgs
              username
              homedir
              gitConfig
              onePasswordConfig
              ;
          })
        ];
      };

      # フォーマッター
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
