{ pkgs, ... }:
{
  home.packages = [ pkgs.sccache ];
  xdg.dataFile."cargo/config.toml".source = ./config.toml;
}
