{ gitConfig, ... }: {
  imports = [
    ./bat/default.nix
    ./eza/default.nix
    ./fzf/default.nix
    ./htop/default.nix
    ./jq/default.nix
    ./ripgrep/default.nix
    ./tmux/default.nix
    ./zoxide/default.nix

    (import ./git/default.nix { config = gitConfig; })
  ];
}
