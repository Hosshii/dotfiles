{ pkgs, lib, ... }:
{
  home.packages = lib.optionals (!pkgs.stdenv.isDarwin) [
    pkgs.docker-client
    pkgs.docker-compose
    pkgs.docker-buildx
  ];
}
