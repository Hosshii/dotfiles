{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ pkgs.raycast ];
  };
}
