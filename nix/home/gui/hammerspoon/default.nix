{ pkgs, lib, config, ... }:

let
  hammerspoon = pkgs.callPackage ./package.nix { };
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ hammerspoon ];

    xdg.configFile."hammerspoon/init.lua".source = ./init.lua;

    targets.darwin.defaults."org.hammerspoon.Hammerspoon" = {
      MJConfigFile = "${config.xdg.configHome}/hammerspoon/init.lua";
    };

    launchd.agents.hammerspoon = {
      enable = true;
      config = {
        ProgramArguments = [
          "/usr/bin/open"
          "-a"
          "${hammerspoon}/Applications/Hammerspoon.app"
        ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };
  };
}
