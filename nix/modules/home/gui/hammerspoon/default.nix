{
  pkgs,
  lib,
  config,
  ...
}:

let
  hammerspoon = pkgs.brewCasks.hammerspoon;
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

    home.activation.hammerspoonAccessibilityGuide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run echo ""
      run echo "⚠️ Hammerspoon requires Accessibility permission"
      run echo "System Settings → Privacy & Security → Accessibility"
      run echo "→ Enable Hammerspoon"
      run echo ""
    '';
  };
}
