{ lib, ... }:
{
  imports = [
    ../base/home.nix
    ../../modules/home/dev
    ../../modules/home/services/agent-notify/default.nix
    ../../modules/home/cli/localtools/default.nix
  ];

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(git wt --init zsh)"
  '';
}
