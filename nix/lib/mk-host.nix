{ inputs }:
let
  mkPkgs = import ./mk-pkgs.nix { inherit inputs; };
  mkHome = import ./mk-home.nix { inherit inputs; };
in
{
  mkDarwinHost =
    {
      host,
      constants,
      homeModule,
      darwinModules ? [ ],
    }:
    let
      pkgs = mkPkgs { system = host.system; };
      llmAgentsPkgs = inputs.llm-agents.packages.${host.system};
    in
    {
      darwinConfigurations."${host.hostname}" = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {
          hostConfig = host;
          inherit constants llmAgentsPkgs;
          self = inputs.self;
        };

        modules = [
          { nixpkgs.pkgs = pkgs; }
          inputs.brew-nix.darwinModules.default
        ]
        ++ darwinModules
        ++ [
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                hostConfig = host;
                inherit constants llmAgentsPkgs;
              };
              users."${host.username}" = homeModule;
            };
          }
        ];
      };

      formatter.${host.system} = pkgs.nixfmt-tree;
    };

  mkHomeHost =
    {
      host,
      constants,
      modules,
    }:
    let
      pkgs = mkPkgs { system = host.system; };
      llmAgentsPkgs = inputs.llm-agents.packages.${host.system};
    in
    {
      homeConfigurations."${host.username}@${host.hostname}" = mkHome {
        inherit
          pkgs
          constants
          modules
          llmAgentsPkgs
          ;
        hostConfig = host;
      };

      formatter.${host.system} = pkgs.nixfmt-tree;
    };
}
