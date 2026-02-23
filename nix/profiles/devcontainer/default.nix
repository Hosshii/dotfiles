{ lib, ... }:
{
  imports = [
    ../../modules/home/cli/bat/default.nix
    ../../modules/home/cli/eza/default.nix
    ../../modules/home/cli/fd/default.nix
    ../../modules/home/cli/fzf/default.nix
    ../../modules/home/cli/git/default.nix
    ../../modules/home/cli/jq/default.nix
    ../../modules/home/cli/ripgrep/default.nix
    ../../modules/home/cli/zoxide/default.nix
    ../../modules/home/cli/direnv/default.nix
    ../../modules/home/cli/zsh/default.nix
    ../../modules/home/dev/claude-code/default.nix
    ../../modules/home/dev/codex/default.nix
    ../../modules/home/services/agent-notify/default.nix
    ../../modules/home/services/macos-remote/default.nix
  ];

  custom.git = {
    delta.enable = lib.mkDefault true;
    wt.enable = lib.mkDefault true;
  };

  programs.zsh.initContent = lib.mkAfter ''
    setopt multios
    eval "$(git wt --init zsh)"
  '';
}
