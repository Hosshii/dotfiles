{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  virtualisation.docker.enable = true;
  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.git
  ];
}
