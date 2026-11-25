{ inputs }:
let
  mkPkgs = import ./mk-pkgs.nix { inherit inputs; };
  mkHome = import ./mk-home.nix { inherit inputs; };

  # Force the configuration's derivation without adding it as a build dependency.
  mkEvaluationCheck =
    pkgs: name: configuration:
    builtins.seq configuration.drvPath (pkgs.writeText "evaluate-${name}" "");
in
{
  mkNixosHost = { host, modules }: {
    nixosConfigurations."${host.hostname}" = inputs.nixpkgs.lib.nixosSystem {
      specialArgs.hostConfig = host;
      modules = [
        { nixpkgs.hostPlatform = host.system; }
      ]
      ++ modules;
    };
  };

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
      configuration = inputs.nix-darwin.lib.darwinSystem {
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
    in
    {
      darwinConfigurations.${host.hostname} = configuration;
      checks.${host.system}."evaluate-${host.hostname}" =
        mkEvaluationCheck pkgs host.hostname
          configuration.system;
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
      name = "${host.username}@${host.hostname}";
      configuration = mkHome {
        inherit
          pkgs
          constants
          modules
          llmAgentsPkgs
          ;
        hostConfig = host;
      };
    in
    {
      homeConfigurations.${name} = configuration;
      checks.${host.system}."evaluate-${name}" =
        mkEvaluationCheck pkgs name
          configuration.activationPackage;
      formatter.${host.system} = pkgs.nixfmt-tree;
    };
}
