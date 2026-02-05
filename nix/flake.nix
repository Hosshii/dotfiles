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
      # === macOS ホスト ===
      darwinSystem = "aarch64-darwin";
      darwinHostname = "andouhanshirous-MacBook-Air";
      darwinUsername = "andouhanshirou";
      darwinHomedir = "/Users/${darwinUsername}";

      # === Arch Linux ホスト ===
      linuxSystem = "x86_64-linux";
      linuxHostname = "hosshiiarch";
      linuxUsername = "hosshii";
      linuxHomedir = "/home/${linuxUsername}";

      # Git 設定 (共通)
      gitConfig = {
        name = "Hosshii";
        email = "sao_heath6147.wistre@icloud.com";
      };

      # 1Password 設定 (macOS のみ)
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

      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};
    in
    {
      # === macOS: nix-darwin + home-manager ===
      darwinConfigurations."${darwinHostname}" = nix-darwin.lib.darwinSystem {
        modules = [
          (import ./darwin/default.nix { system = darwinSystem; pkgs = darwinPkgs; homedir = darwinHomedir; inherit self; })
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."${darwinUsername}" = import ./hosts/macbook/home.nix {
                username = darwinUsername;
                homedir = darwinHomedir;
                inherit gitConfig onePasswordConfig;
              };
            };
          }
        ];
      };

      # === Arch Linux: standalone home-manager ===
      homeConfigurations."${linuxUsername}@${linuxHostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [
          (import ./hosts/archlinux/home.nix {
            username = linuxUsername;
            homedir = linuxHomedir;
            inherit gitConfig;
          })
          { nixpkgs.config.allowUnfree = true; }
        ];
      };

      # フォーマッター
      formatter.${darwinSystem} = darwinPkgs.nixpkgs-fmt;
      formatter.${linuxSystem} = linuxPkgs.nixpkgs-fmt;
    };
}
