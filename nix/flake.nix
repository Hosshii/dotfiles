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
      macbook = import ./hosts/macbook { inherit inputs; };
      archlinux = import ./hosts/archlinux { inherit inputs; };
    in
    {
      inherit (macbook) darwinConfigurations;
      inherit (archlinux) homeConfigurations;
      formatter = macbook.formatter // archlinux.formatter;
    };
}
