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

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    let
      # システムアーキテクチャ（Apple Silicon）
      system = "aarch64-darwin";
      hostname = "andouhanshirous-MacBook-Air";
      username = "andouhanshirou";
      homedir = /Users/${username};

      pkgs = import nixpkgs {
        inherit system;
      };

      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [
            pkgs.vim
          ];

        # installed via determinate
        nix.enable = false;
        system = {
          # Set Git commit hash for darwin-version.
          configurationRevision = self.rev or self.dirtyRev or null;
          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          stateVersion = 6;
        };

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = system;

        programs.zsh.shellInit = ''
          # Set up Nix only on SSH connections
          # See: https://github.com/DeterminateSystems/nix-installer/pull/714
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ] && [ -n "''${SSH_CONNECTION:-}" ] && [ "''${SHLVL:-0}" -eq 1 ]; then
              . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi
          # End Nix
          export ZDOTDIR="$HOME"/.config/zsh
        '';
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
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
                };
              };
            };
          }
        ];
      };

      # フォーマッター
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
