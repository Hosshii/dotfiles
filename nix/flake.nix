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
              extraSpecialArgs = {
                hostConfig = {
                  username = darwinUsername;
                  homedir = darwinHomedir;
                };
              };
              users."${darwinUsername}" = import ./hosts/macbook/home.nix;
            };
          }
        ];
      };

      # === Arch Linux: standalone home-manager ===
      homeConfigurations."${linuxUsername}@${linuxHostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        extraSpecialArgs = {
          hostConfig = {
            username = linuxUsername;
            homedir = linuxHomedir;
          };
        };
        modules = [
          ./hosts/archlinux/home.nix
          { nixpkgs.config.allowUnfree = true; }
        ];
      };

      # フォーマッター
      formatter.${darwinSystem} = darwinPkgs.nixpkgs-fmt;
      formatter.${linuxSystem} = linuxPkgs.nixpkgs-fmt;
    };
}
