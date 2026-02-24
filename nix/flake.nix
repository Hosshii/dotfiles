{
  description = "dotfiles managed with nix-darwin and home-manager";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

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

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    op-broker = {
      url = "github:Hosshii/op-broker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nix-darwin
    , home-manager
    , brew-nix
    , brew-api
    , claude-code-overlay
    , llm-agents
    , op-broker
    }:
    let
      macbook = import ./hosts/macbook { inherit inputs; };
      archlinux = import ./hosts/archlinux { inherit inputs; };
      devcontainer = import ./hosts/devcontainer { inherit inputs; };
    in
    {
      inherit (macbook) darwinConfigurations;
      homeConfigurations = archlinux.homeConfigurations // devcontainer.homeConfigurations;
      homeManagerModules.devcontainer = import ./profiles/devcontainer/default.nix;
      formatter = macbook.formatter // archlinux.formatter // devcontainer.formatter;
    };
}
