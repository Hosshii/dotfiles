{ pkgs, config, ... }:
{
  home.packages = [ pkgs.claude-code ];

  xdg.configFile."claude-code" = {
    source = ./config;
    recursive = true;
  };

  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude-code";
  };
}
