{ pkgs, lib, ... }:
{
  home.packages =
    lib.optionals pkgs.stdenv.isDarwin [ pkgs.macos-remote-server ]
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.macos-remote ];
}
