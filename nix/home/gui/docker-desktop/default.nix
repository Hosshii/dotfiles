{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ pkgs.brewCasks.docker-desktop ];
  };
}
