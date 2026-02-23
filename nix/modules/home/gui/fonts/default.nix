{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.hackgen-nf-font ];
}
